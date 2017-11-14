#!/bin/sh
#
# Branch names:
# * feature/<issue-id>
# * bug/<issue-id>

RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'
branch_name=`git rev-parse --abbrev-ref HEAD`

echo $branch_name | grep -Ev '^((feature|bug)/ABC-[0-9]{1,5})$' >/dev/null && {
    echo "${RED}"
    echo >&2 "Invalid branch name '${branch_name}'"
    echo "${CYAN}"
    exec 1>&2
    cat <<\EOF
Valid names:

* feature/<issue-id>
* bug/<issue-id>

Rename your current branch with:
    git branch -m <new-name>
EOF
	echo "${NC}"
    exit 1;
}

exit 0;
