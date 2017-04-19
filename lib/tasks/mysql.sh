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
# This method execute a task of type "mysql"
# @param taskName The name of the task to execute
##
function ib_task_mysql_run() {
    local taskName="$1";
    local mysqlHost=$(ib_get_conf_value "IB_TASK_${taskName}_HOST")
    local mysqlPort=$(ib_get_conf_value "IB_TASK_${taskName}_PORT")
    local mysqlUser=$(ib_get_conf_value "IB_TASK_${taskName}_USER")
    local mysqlPassword=$(ib_get_conf_value "IB_TASK_${taskName}_PASSWORD")
    local mysqlDumpOpts=$(ib_get_conf_value "IB_TASK_${taskName}_DUMP_OPTS")
    local mysqlDatabases=$(ib_get_conf_value "IB_TASK_${taskName}_DATABASES")
    local storageName=$(ib_get_conf_value "IB_TASK_${taskName}_STORAGE")

    [ -z "$mysqlHost" ] && mysqlHost="localhost"
    [ -z "$mysqlPort" ] && mysqlPort="3306"
    [ -z "$mysqlUser" ] && mysqlPort="root"
    [ -z "$mysqlPassword" ] && mysqlPassword=""
    [ -z "$mysqlDumpOpts" ] && mysqlDumpOpts="--opt"
    [ -z "$mysqlDatabases" ] && mysqlDatabases="__ALL__"

    [ -z "$storageName" ] && echo "No valid IB_TASK_${taskName}_STORAGE found" && return -1

    if [[ "$mysqlDatabases" ==  "__ALL__" ]]
    then
        mysqlDatabases=$(mysql --batch --raw --skip-pager --skip-column-names -h "$mysqlHost" \
                       --port "$mysqlPort" -u "$mysqlUser" "-p$mysqlPassword" \
                       --execute='SHOW DATABASES')

    	[ -z "$mysqlDatabases" ] && echo "Can't list mysql databases on server [$mysqlHost]" && return -1
    fi

    for database in $mysqlDatabases
    do
        [[ ($database == "information_schema") || ($database == "performance_schema") ]] && continue

        mysqldump -h "$mysqlHost" --port "$mysqlPort" -u "$mysqlUser" "-p$mysqlPassword" \
              $mysqlDumpOpts "$database" | gzip | \
            ib_storage_run "$storageName" "$taskName" "${database}-${DATE}.sql.gz" || return -1
    done
    return 0;
}
