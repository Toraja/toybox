#### System-wide configuration
`/etc/inputrc`  
<br>

#### User only
`~/.inputrc`  
Make sure to add "$include /etc/inputrc" to the above so that it does not break original function.  
<br>

#### Not so fast
If you don't want inputrc to be loaded automatically, create your own inputrc and load it with:  
`bind -f *filename*`  
