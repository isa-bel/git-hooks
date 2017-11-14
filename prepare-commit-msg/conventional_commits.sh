#!/bin/sh
#
# Add conventional commits prefixes
# * if 'feature/ABC-1234', add 'feat: ABC-1234'
# * if 'bug/ABC-1234', add 'fix: ABC-1234'
# * else add nothing

commit_msg=$1
commit_mode=$2
subject_line=`head -n1 $commit_msg`

# If the user used `git commit` and is not an amend
if [ -z "$commit_mode" -o "$commit_mode" = "commit" ] && [ -z "$subject_line" ] ; then

    branch=`git rev-parse --abbrev-ref HEAD`

    echo $branch | grep -E '^feature/ABC-[0-9]{1,5}$' >/dev/null && {
        ticket=${branch##*/}
        sed -i '' "1s/^/feat: $ticket /" $commit_msg
    }

    echo $branch | grep -E '^bug/ABC-[0-9]{1,5}$' >/dev/null && {
        ticket=${branch##*/}
        sed -i '' "1s/^/fix: $ticket /" $commit_msg
    }
fi

exit 0;
