#!/bin/sh
#
# Add issue number prefix
# * if '*/ABC-1234/*', add 'ABC-1234 '
# * else add nothing

commit_msg=$1
commit_mode=$2
subject_line=`head -n1 $commit_msg`

# If the user used `git commit` and is not an amend
if [ -z "$commit_mode" -o "$commit_mode" = "commit" ] && [ -z "$subject_line" ] ; then

    branch=`git rev-parse --abbrev-ref HEAD`

    echo $branch | grep -E '^[a-z]+/ABC-[0-9]{1,5}$' >/dev/null && {
        ticket=${branch##*/}
        sed -i '' "1s/^/$ticket /" $commit_msg
    }
fi

exit 0;
