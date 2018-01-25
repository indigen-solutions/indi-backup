################################################################################
#
# The MIT License (MIT)
#
# Copyright (c) 2015 Indigen-Solution
# See the AUTHORS file for details.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
################################################################################

##
# This method execute a storage stream of type ssh that store item on a
#   remote ssh server
# @param storageName The name of the storage stream to execute
# @param taskName The name of the task to execute
# @param itemName The name of the item you want to store
##
function ib_storage_ssh_run() {
    local storageName="$1"
    local taskName="$2"
    local itemName="$3"
    local itemTag="$4"
    local sshUser=$(ib_get_conf_value "IB_STORAGE_${storageName}_USER")
    local sshHost=$(ib_get_conf_value "IB_STORAGE_${storageName}_HOST")
    local sshPort=$(ib_get_conf_value "IB_STORAGE_${storageName}_PORT")
    local sshBasePath=$(ib_get_conf_value "IB_STORAGE_${storageName}_BASEPATH")
    local sshKey=$(ib_get_conf_value "IB_STORAGE_${storageName}_SSHKEY")

    [ -z "$sshUser" ] && echo "No valid IB_STORAGE_${storageName}_USER found" && return -1
    [ -z "$sshHost" ] && echo "No valid IB_STORAGE_${storageName}_HOST found" && return -1
    [ -z "$sshBasePath" ] && echo "No valid IB_STORAGE_${storageName}_BASEPATH found" && return -1

    [ -z "$sshPort" ] && sshPort=22

    [[ (! -z "$sshKey") && ( ! -r "$sshKey" ) ]] && echo "Can'r read ssh key $sshKey" && return -1

    [ ! -z "$sshKey" ] && sshKey="-i ${sshKey}"

    local folderName="${DATE}"
    [ ! -z "$itemTag" ] && folderName="${folderName}-${itemTag}"

    local fileName="${sshBasePath}/${taskName}/${folderName}/${itemName}"
    ssh  $sshKey -p "${sshPort}" "${sshUser}@${sshHost}" "mkdir -p \"\$(dirname '${fileName}')\" ; cat > '${fileName}'"
}

##
# This method remove backup older than retention
# @param storageName The name of the storage stream to execute
# @param taskName The name of the task to execute
# @param retention The name of the item you want to store
##
function ib_storage_ssh_prune() {
    local storageName="$1"
    local taskName="$2"
    local retention="$3"
    local sshUser=$(ib_get_conf_value "IB_STORAGE_${storageName}_USER")
    local sshHost=$(ib_get_conf_value "IB_STORAGE_${storageName}_HOST")
    local sshPort=$(ib_get_conf_value "IB_STORAGE_${storageName}_PORT")
    local sshBasePath=$(ib_get_conf_value "IB_STORAGE_${storageName}_BASEPATH")
    local sshKey=$(ib_get_conf_value "IB_STORAGE_${storageName}_SSHKEY")

    [ -z "$sshUser" ] && echo "No valid IB_STORAGE_${storageName}_USER found" && return -1
    [ -z "$sshHost" ] && echo "No valid IB_STORAGE_${storageName}_HOST found" && return -1
    [ -z "$sshBasePath" ] && echo "No valid IB_STORAGE_${storageName}_BASEPATH found" && return -1

    [ -z "$sshPort" ] && sshPort=22

    [[ (! -z "$sshKey") && ( ! -r "$sshKey" ) ]] && echo "Can'r read ssh key $sshKey" && return -1

    [ ! -z "$sshKey" ] && sshKey="-i ${sshKey}"


    local dirName="${sshBasePath}/${taskName}/"
    backups=$(ssh $sshKey -p "${sshPort}" "${sshUser}@${sshHost}" "ls \"${dirName}\"")

    local toRemove=""
    for backup in ${backups}
    do
        ib_should_be_prune "${backup}" "$retention" && toRemove="${toRemove} \"${dirName}/${backup}\""
    done

    [ ! -z "$toRemove" ] && ssh $sshKey -p "${sshPort}" "${sshUser}@${sshHost}" "rm -r ${toRemove}"
    return 0
}