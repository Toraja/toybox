---
syntax: markdown
---

### Add worktree branch wish its name being 'sub'
`git worktree add -b sub <path>`

### Track remote main branch
`git pull` pulls changes if remote has been updated  
`git branch -u origin/main`

### Track local main branch
`git pull` pulls changes only if the changes have been applied to the local branch  
`git branch -u main`

### Workaround for missing .git/info/exclude
Add files/directories you want to ignore to `.gitignore`, then run the below command
`git update-index --skip-worktree -- .gitignore`

If changes to `.gitignore` are made in the upstream, `git pull` will fail.  
Run the below command to revert the effect.  
`git update-index --no-skip-worktree -- .gitignore`  
`git stash [--include-untracked]`
