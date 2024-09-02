---
syntax: markdown
---

# Use like bash
`bass` fish plugin is required for this.

## Export variables that a command emits
e.g. `<command>` emits `A=apple` and you want to set it as environment variable for shell.
```sh
bass export (<command>)
```

# Here Document
It is not (and probably will never be) supported in fish.
Use `echo` instead.
```sh
echo "
foobar
barfoo
" | sed 's/foo/bar/g' > output.txt
```

# Command history

## Update history of current session
```sh
history --merge
```
