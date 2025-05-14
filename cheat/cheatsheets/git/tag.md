---
syntax: markdown
---

# If git complains that it "would clobber existing tag"
```sh
git fetch --tags -f
```

# List
## Tags that matches the pattern
```sh
git tag [-l (pattern)]
```
## Tags and their hash (not the commit hash the tags are attached to)
```sh
git show-ref --tags
```
