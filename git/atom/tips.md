## Tips

### Disable MRU Tab switching
Setting -> Package -> search for package _tabs_ -> Go to the package setting  
Uncheck *Enable MRU Tab Switching*

### Prevent default keybindings are fired when auto-completion window is opened
Setting -> Package -> search for package _autocomplete-plus_ -> Go to the package setting  
Uncheck *Use Core Movement Commmands*  

### Navigate auto-completion window with your own keybindings
Reference: [GitHub - atom/autocomplete-plus](https://github.com/atom/autocomplete-plus#remapping-movement-commands)  
To close the window: `autocomplete-plus:cancel`  
To select the suggestion: `autocomplete-plus:confirm`  
