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
# This method execute a task of type "subtask"
# @param taskName The name of the task to execute
##
function ib_task_subtask_run() {
    local taskName="$1";
    local subtasks=$(ib_get_conf_value "IB_TASK_${taskName}_SUBTASKS")

    if [ -z "$subtasks" ]; then echo "No valid IB_TASK_${taskName}_SUBTASKS found"; return -1; fi

    for subtask in $subtasks
    do
	if ! ib_task_run $subtask
	then
	    return -1;
	fi
    done
    return 0;
}

