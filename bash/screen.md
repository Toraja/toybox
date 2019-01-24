## Screen

<mark>NOTE</mark> <span>All the commands must be preceded by command key (`Ctrl-A` by
default, `Ctrl-Z` in my configuration)</span>  

### Start/End
|     Description     | Command |      Key      |
|:-------------------:|:-------:|:-------------:|
|  Start new session  |  screen | `Ctrl-C`, `c` |
| End current session |   kill  |    `k`, `K`   |
|   Quit all screen   |   quit  |      `\ `     |

### Split
<mark>NOTE</mark> <span>Split only opens an empty window. You need to focus the window and start a
new shell.</span>  
|                             Description                             |  Command |    Key   |
|:-------------------------------------------------------------------:|:--------:|:--------:|
|                          Split horizontally                         |   split  |    `S`   |
|                           Split vertically                          | split -v |   `\|`   |
|                          Focus next window                          |   focus  | `Ctrl-I` |
|                         Close current window                        |  remove  |    `X`   |
| Close other windows<br>(sessions in closed windows are still alive) |   only   |    `Q`   |

### Copy/Paste
|                       Description                      |  Command |        Key       |
|:------------------------------------------------------:|:--------:|:----------------:|
| Enter copy mode<br>(let you move around on the screen) |   split  |   `[`, `Ctrl-[`  |
|            Start/End selecting in copy mode            | split -v | `Space`, `Enter` |
|                          Paste                         |   paste  |   `]`, `Ctrl-]`  |

### Misc
|  Description | Command | Key |
|:------------:|:-------:|:---:|
| Display help |   help  | `?` |
