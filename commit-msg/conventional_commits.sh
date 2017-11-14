#!/bin/sh
#
# Commit message format:
# * feat: ABC-1234 Add a cool feature
# * fix: ABC-1234 Fix a problem with indexing
#
# Also applies the commit message guidelines from https://chris.beams.io/posts/git-commit/

RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'
commit_msg=$1
msg_length=`cat "$commit_msg" | wc -l`
subject_line=`head -n1 $commit_msg`

# $1 text to test
# $2 regex to test with
# $3 error message
function testRegex {
    echo $1 | grep -E "$2" >/dev/null && {
        echo >&2 $3;
        has_errors=1;
    }
}

echo "${RED}"

# 1. Separate the subject from the body with a blank line
if [ $msg_length -gt 1 ]; then
    second_line=`cat "$commit_msg" | head -2 | tail -1`
    testRegex "$second_line" '^\S+$' "Second line must be empty, is '${second_line}'"
fi
# 2. Limit the subject line to 50 characters
testRegex "$subject_line" '^..{50}' 'Subject line exceeds 50 characters limit'

# Add the conventional commits prefix
echo $subject_line | grep -Ev '^(feat:|fix:)' >/dev/null && {
    echo >&2 "Subject line has no conventional commits prefix";
    has_errors=1;
}
# Follow the prefix with the issue id
echo $subject_line | grep -Ev '^(feat:|fix:) ABC-[0-9]{1,5}' >/dev/null && {
    echo >&2 "Subject line has no issue id";
    has_errors=1;
}
# 3. Start the subject line description with a capital letter
echo $subject_line | grep -Ev '^(feat:|fix:) ABC-[0-9]{1,5} [A-Z]' >/dev/null && {
    echo >&2 "Subject line is not capitalized";
    has_errors=1;
}
# 4. Don't end the subject line with a period
testRegex "$subject_line" '\.$' 'Subject line ends with a period'

# 5. Use the imperative mood in the subject line
# 6. Wrap the body at 72 characters
if [ $msg_length -gt 2 ]; then
    body_lines=`cat "$commit_msg" | tail -n +2 | grep -ve '^#'`
    line_index=0;
    while IFS= read -r body_line;
    do 
        testRegex "$body_line" '^..{72}' "Body line ${line_index} exceeds 72 char limit"
        (( line_index++ ))
    done <<< "$body_lines"
fi
# 7. Use the body to explain what and why vs. how

if [ $has_errors ]; then
    echo >&2 ""
    echo >&2 "Invalid commit message:"
    echo >&2 "  `cat ${commit_msg}`"
    echo "${CYAN}"
    exec 1>&2
    cat <<\EOF
Commit message format:
* feat: ABC-1234 Add a cool feature
* fix: ABC-1234 Fix a problem with indexing
EOF
    echo "${NC}"
    exit 1;
fi

echo "${NC}"
exit 0;
