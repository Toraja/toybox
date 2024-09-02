# View files

## View file content at the commit / in the branch
```sh
git show <commitish>:<path>
```

# Pull / Fetch
## Pull without switching to the branck
```sh
git fetch origin <branch>:<branch>
```

# Chores

## Shrink .git directory
```sh
ref: https://stackoverflow.com/questions/5613345/how-to-shrink-the-git-folder
```

## Run this command if lfs is used
```sh
git lfs prune
```

## Shrink .git/objects
```sh
git gc
git prune
```
