#!/bin/sh
#
# Branch names:
# (feat|bug|test|junk|doc)/[<issue-id>/]<description-slug>


RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'
branch_name=`git rev-parse --abbrev-ref HEAD`

echo $branch_name | grep -Ev '^((feat|bug|test|junk|doc)/(ABC-[0-9]{1,5}/)?[a-z][a-z0-9\-]+)$' >/dev/null && {
    echo "${RED}"
    echo >&2 "Invalid branch name '${branch_name}'"
    echo "${CYAN}"
    exec 1>&2
    cat <<\EOF
Branch name parts:

<grouping-token>/<issue-id>/<description-slug>

Valid grouping tokens:

* feat
* bug
* test
* junk
* doc

Issue id is optional.

Rename your current branch with:
    git branch -m <new-name>
EOF
	echo "${NC}"
    exit 1;
}

exit 0;
