---
syntax: markdown
---

# Add worktree branch wish its name being 'sub'
```sh
git worktree add -b sub <path>
```

# Track remote main branch
`git pull` pulls changes if remote has been updated
```sh
git branch -u origin/main
```

# Track local main branch
`git pull` pulls changes only if the changes have been applied to the local branch
```sh
git branch -u main
```

# Ignore files locally in worktree

## Ignore files in all worktrees (including main worktree)
Simply add the files to `.git/info/exclude` in the main worktree.

## Ignore files only in the linked worktree
Add files/directories you want to ignore to `.gitignore` in the worktree, then run the below command
> [!NOTE]
> This command is only effective to files that are already tracked
```sh
git update-index --skip-worktree -- .gitignore
```

If changes to `.gitignore` are made in the upstream, `git pull` will fail.  
Run the below command to revert the effect.
```sh
git update-index --no-skip-worktree -- .gitignore
git stash [--include-untracked]
```
