## Notes about Git

### Start git
#### Initialize git repository
(prerequisite: create git repository on github)
1. create a new repository on the command line  
```
echo "## (repository name)" >> README.md  
git init	<-- create .git file and start tracking  
git add README.md  
git commit -m "first commit"  
git remote add origin *repository URL*  
git push --set-upstream origin master
```
2. push an existing repository from the command line  
```
git remote add origin *repository URL*  
git push --set-upstream origin master
```

#### Clone existing repository
`git clone (repository URL)`

---

### Daily routine
#### apply remote modification to local
`git pull`

#### Diplay status of the current branch
`git status [-s]`  
```
??: untracked  
A : added but not pushed  
D : removed but not pushed  
M : modify has been tracked  
 D: removed locally and not tracked  
 M: modified but not tracked  
AM: modified after added
```

#### Check whether local repo is ahead/behind the remote
`git remote show origin`  
on the last line, if it says  
[up to date] then local and remote are on the same commit  
[fast-forwardable] then local is ahead  
[out of date] then local is behind

#### Updates remote-tracking repository
`git fetch`
Remote changes will be applied to remote tracking repository.  
This enables git status to compare the local with remote (message like *git remote show origin* outputs will be displayed)
as well as git diff origin/remote to compare remote and local files.  

#### Newly created files must be added to the index
`git add [filename...]`

#### Commit the changes (not uploaded to the remote yet)
`git commit [files...] -m "comment"`  
`git commit -am "comment"`  
Without `-m` option, editor will be opened to write comment.  
With `-v` option, modifications will be shown (like `-p` option) in the editor.  
If files are not specified, files added (tracked) by git-add are committed.  
`-a` option commits all the modification  
Committing when there are changes that have not been pulled causes branch merge when pushing.

#### Upload the current index to the remote repo
`git push`  
Pushing before pulling remote changes to local repository fails.

---
### Oops...
#### Remove files from the current index (the "about to commited" area)
`git reset <file>`  

#### Revert the specified commit
`git revert <commitID>`  

---

### Make informed decision
#### Diplay the history of commit
`git log`  
**options**  
`-n` -> *n* is an arbitrary number. Last *n* commits will be shown.  
`--reverse` -> reverse the order  
`--oneline` -> display every commit in oneline  
`--pretty=format: [string]` -> display log according to the [string]  

#### Display file names of particular commit
`git diff-tree --no-commit-id --name-only -r <commitID>`  

#### Get the contents of particular file of particular commit
`git show <commit>:path/to/file`  
Path must be separated by forward slash.  
\<commit> can be replaced with \<branch> to display files in another branch.  
Notice the semi colon!

#### Compare two commits
`git diff <commit> [<commit>] [path]`  
Separator of the path can be either forward/backwark slash.  
Without the second \<commit>, git compares with HEAD.

#### Compare local and remote
`git difftool master origin/master`  

---

### Temporarily put away changes
#### Stash away uncommited changes
`git stash [save [message]]`
#### Bring back the stashed change
`git stash pop/apply`  
git pop removes the stash while git apply doesn't
#### Remove stash
`git drop [<stash>]`

---

### Branch related
#### change the name of branch
`git branch -m oldName newName`  

---

### Rename remote repo
#### get the name of remote repo
`git remote -v`  

#### delete the remote repo
`git push origin :oldName`  

#### Re-create the remote branch with the new name
`git push origin newName`  

---

### Tag related
#### List tags
`git tag [-l (pattern)]`  
With `-l` option, git shows tags that matches the pattern.  
`git tag -n`  
List tags with annotation messages  
`git rev-list --pretty=oneline <commit>`  
List commit IDs and corresponding messages of \<commit> and earlier.  
`git rev-list --pretty=oneline --tags=<pattern> -n`  
List commit IDs and corresponding messages the tag of which matches the \<pattern>.  
It seems that \<pattern> must contain wildcard(\*).  
`git ls-remote --tags`  
List remote tags.

#### Add tags
`git tag -a (tag name) [<commit>] -m (message)`
git-tag adds a tag to HEAD or specified commit.  
One tag can be attached to one tag only.  

---

### Misc
#### Use git on cygwin
##### SSH
To use git on cygwin and share the ssh setting with windows, the permission of ~/.ssh/config needs
to be changed.  
1. The permission needs to be 600  
2. setfacl ~/.ssh/config (not sure if necessary)  
3. chown [username]:Users ~/.ssh/config  

Reference:
[Setting up SSH/Git on Cygwin yields "Bad permissions on ~/.ssh/config"](https://superuser.com/questions/533381/setting-up-ssh-git-on-cygwin-yields-bad-permissions-on-ssh-config)
