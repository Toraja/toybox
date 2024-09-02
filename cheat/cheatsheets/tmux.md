---
syntax: markdown
---

# Session

## List sessions
```
list-sessions
```

## List windows in a session
```
list-windows <session>
```

# Window

## Renumber Windows
```
move-window -r
```

## Move window between sessions
NOTE: as of v3.2a, -r option to renumber window does not work for inter-session move.

### Push current window to another session
Without `window`, the current window is appended to the session
```
move-window -t <session>:[window]
```

### Take window to from another session
Without `source window`, the active window of the specified session is taken.
With `dest window`, you can put the window at the index if the index is not used.
```
move-window -s <session>:[source window] [-t dest window]
```
