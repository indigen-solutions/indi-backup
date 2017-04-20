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
# This method execute a task decalred in the config file
# @param taskName The name of the task to execute
# @description This method loop through task declared in IB_TASKS and if it
#   find task passed as parameter it call the right method according to the task
#   type.
##
function ib_task_run() {
    local taskName="$1"

    echo "Starting task ${taskName}"
    for task in $IB_TASKS
    do
        if [[ "$task" == "$taskName" ]]
        then
            local taskType=$(ib_get_conf_value "IB_TASK_${taskName}_TYPE")
            local taskRetention=$(ib_get_conf_value "IB_TASK_${taskName}_RETENTION")
            local storageName=$(ib_get_conf_value "IB_TASK_${taskName}_STORAGE")

            if [ -z "$taskRetention" ];then taskRetention="15days"; fi

            case  "$taskType" in
            subtask)
                ib_task_subtask_run "$taskName" || return -1
                ;;
            mongo)
                ib_task_mongo_run "$taskName" || return -1
                ;;
            mysql)
                ib_task_mysql_run "$taskName" || return -1
                ;;
            tarball)
                ib_task_tarball_run "$taskName" || return -1
                ;;
            tarball-incremental)
                ib_task_tarball-incremental_run "$taskName" || return -1
                ;;
            docker-mysql-dumper)
                ib_task_docker-mysql-dumper_run "$taskName" || return -1
                ;;
            *)
                echo "Unknow task type [$taskType]"
                return -1
                ;;
            esac

            if [ ! -z "$storageName" ]
            then
              ib_storage_prune "$storageName" "$taskName" "$taskRetention" || return -1
            fi
            echo "Task ${taskName} success"
            return 0
        fi
    done
    echo "No task [$taskName] found"
    return -1;
}

##
# This method list all the registered tasks in the configuration file.
##
function ib_task_list() {
    for taskName in $IB_TASKS
    do
	local type=$(ib_get_conf_value "IB_TASK_${taskName}_TYPE")
	echo " * ${taskName}"
	echo "   - Type: ${type}"
    done
}
