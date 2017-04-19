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

function ib_get_conf_value() {
    local varname="$1"
    if [[ -z "${!varname}" ]]
    then
	return -1
    fi
    echo "${!varname}"
    return 0
}

##
# This function return true if a given backup should be prune according to
# retention policies
# @param backup The backup name
# @param retention the retention policy
##
function ib_should_be_prune() {
    local backup="$1"
    local retention="$2"

    local retentionDate=$(date -d "now - ${retention}" --utc "+%Y%m%dT%H%M%SZ")
    [ ${backup} \< ${retentionDate} ]
    return $?
}

function ib_print_usage() {
    echo "USAGE"
    echo "  indi-backup [options] tasks ..."
    echo ""
    echo "OPTIONS"
    echo "  -c path, --config path"
    echo "    Overide the default config file location. (/etc/indi-backup.conf)"
    echo "  -h, --help"
    echo "    Show summary of options"
    echo "  --version"
    echo "    Print the version and exit"
    echo "  --list-tasks"
    echo "    List all available tasks"
    echo "  --list-storages"
    echo "    List all available storages"
}
