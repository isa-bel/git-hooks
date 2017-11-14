# git-hooks

Sets of git hooks to verify branch naming and commit messages conventions.
Tested for macOS only.

* The `pre-commit` hook validates the branch naming conventions.
* The `prepare-commit-msg` hook appends to the commit message autogenerated information, such as JIRA tracker number.
* The `commit-msg` hook validates the commit messages conventions.


## How do I install a git hook?

To install a git hook:

1. Copy the git hook file to your repository `.git/hooks/` directory.
2. In your repository, rename the git hook file to the original hook _directory_ without extension. 
3. Verify the git hook file is executable.
4. If necessary, edit the hook script to fit your conventions.

Example:

```bash
cp pre-commit/feature_bug.sh MY_REPO/.git/hooks/
cd MY_REPO/.git/hooks
mv feature_bug.sh pre-commit
chmod +x pre-commit
ls -al pre-commit
  -rwxr-xr-x@ 1 user  staff  610 Jan  1 12:34 pre-commit
```

## Hooks Output Examples

### `pre-commit` Example

* Hook `pre-commit/feature_bug.sh`
* Branch name `fix/ABC-123`
* Command `git commit`

Output:

```
Invalid branch name 'fix/ABC-123'

Valid names:
* feature/<issue-id>
* bug/<issue-id>

Rename your current branch with:
    git branch -m <new-name>
    
```

### `commit-msg` Example

* Hook `commit-msg/conventional_commits.sh`
* Command `git commit -m 'add a search component and fix the bug with the input field.'`

Output:

```
Subject line exceeds 50 characters limit
Subject line has no conventional commits prefix
Subject line has no issue id
Subject line is not capitalized
Subject line ends with a period

Invalid commit message:
  add a search component and fix the bug with the input field.

Commit message format:
* feat: DPP-1234 Add a cool feature
* fix: DPP-1234 Fix a problem with indexing
```

### `prepare-commit-msg` Example

* Hook `prepare-commit-msg/prepare-commit-msg.sh`
* Branch name `feat/ABC-123`
* Command `git commit`

Commit editor:

```
ABC-123 
# Please enter the commit message for your changes. Lines starting
...
```