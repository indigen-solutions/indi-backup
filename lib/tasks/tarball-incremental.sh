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
# This method execute a task of type "tarball-incremental"
# @param taskName The name of the task to execute
##
function ib_task_tarball-incremental_run() {
    local taskName="$1"
    local folders=$(ib_get_conf_value "IB_TASK_${taskName}_FOLDERS")
    local listFile=$(ib_get_conf_value "IB_TASK_${taskName}_LIST_FILE")
    local fileBaseName=$(ib_get_conf_value "IB_TASK_${taskName}_FILE_BASENAME")
    local storageName=$(ib_get_conf_value "IB_TASK_${taskName}_STORAGE")
    local masterFrequency=$(ib_get_conf_value "IB_TASK_data2_MASTER_FREQUENCY")
    local masterFrequencyValue=$(ib_get_conf_value "IB_TASK_data2_MASTER_FREQUENCY_VALUE")

    if [ -z "$storageName" ]; then echo "No valid IB_TASK_${taskName}_STORAGE found"; return -1; fi
    if [ -z "$listFile" ]; then echo "No valid IB_TASK_${taskName}_LIST_FILE found"; return -1; fi
    if [ -z "$folders" ]; then echo "No valid IB_TASK_${taskName}_FOLDERS found"; return -1; fi

    if [ -z "$fileBaseName" ]
    then
	fileBaseName="backup"
    fi

    if [ -z "$masterFrequency" ]
    then
	masterFrequency="weekly"
	masterFrequencyValue=1
    fi

    if [ -z "$masterFrequencyValue" ]
    then
	masterFrequencyValue=1
    fi

    echo $masterFrequency $masterFrequencyValue
    if [[ (( "$masterFrequency" == "weekly" ) && ( $(date "+%u") -eq "$masterFrequencyValue" )) || \
	      (( "$masterFrequency" == "monthly" ) && ( $(date "+%d") -eq "$masterFrequencyValue" )) ]]
    then
	rm -f "$listFile"
    fi

    tar --create -z --listed-incremental=$listFile $folders \
	| ib_storage_run $storageName $taskName "${fileBaseName}-${DATE}.tar.gz"
}