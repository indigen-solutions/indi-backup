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
# This method execute a storage stream of type swift that store item on a
#   swift server
# @param storageName The name of the storage stream to execute
# @param taskName The name of the task to execute
# @param itemName The name of the item you want to store
##
function ib_storage_swift_run () {
    local storageName="$1"
    local taskName="$2"
    local itemName="$3"
    local itemTag="$4"
    local swiftAuthUrl=$(ib_get_conf_value "IB_STORAGE_${storageName}_AUTHURL")
    local swiftUser=$(ib_get_conf_value "IB_STORAGE_${storageName}_USER")
    local swiftPassword=$(ib_get_conf_value "IB_STORAGE_${storageName}_PASSWORD")
    local swiftBasePath=$(ib_get_conf_value "IB_STORAGE_${storageName}_BASEPATH")
    local swiftContainer=$(ib_get_conf_value "IB_STORAGE_${storageName}_CONTAINER")
    local swiftSplitSize=$(ib_get_conf_value "IB_STORAGE_${storageName}_SPLIT_SIZE")

    echo "WARNING: Swift storage is deprecated"

    if [ -z "$swiftAuthUrl" ]; then echo "No valid SWIFT_AUTHURL found"; return -1; fi
    if [ -z "$swiftUser" ]; then echo "No valid SWIFT_USER found"; return -1; fi
    if [ -z "$swiftPassword" ]; then echo "No valid SWIFT_PASSWORD found"; return -1; fi
    if [ -z "$swiftBasePath" ]; then echo "No valid SWIFT_BASEPATH found"; return -1; fi
    if [ -z "$swiftContainer" ]; then echo "No valid SWIFT_CONTAINER found"; return -1; fi

    if [ -z "$swiftSplitSize" ]
    then
	swiftSplitSize="2G"
    fi

    local folderName="${DATE}"
    if [ ! -z "$itemTag" ]
    then
	folderName="${folderName}-${itemTag}"
    fi

    stdin2swift -a "$swiftAuthUrl" -u "$swiftUser" -p "$swiftPassword" -s "$swiftSplitSize" \
		"$swiftContainer" "${swiftBasePath}/${taskName}/${folderName}/${itemName}"
}

##
# This method remove backup older than retention
# @param storageName The name of the storage stream to execute
# @param taskName The name of the task to execute
# @param retention The name of the item you want to store
##
function ib_storage_swift_prune() {
    echo "WARNING: Prune on swift storage is not supported yet"
    retrun 0
}