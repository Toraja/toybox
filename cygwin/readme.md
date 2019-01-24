## Configuration
### Change home directory
**Method 1** - Edit /etc/nsswitch.conf  
Set the value of *db_home:* to *windows* and home directory will be same as windows.  

**Method 2** - Set environment variable  
Set *HOME* environment variable and home directory will be the value of the variable.  
If cygwin is launched via a console (cmd or powershell), its variable (%HOME% or $env:HOME) will be
used to set home directory of cygwin.  

### Always open as maximised
Add below to *minttyrc*  
`Window=max`  

When opening cygwin with Ctrl+Shift+N, font size will be smaller without this.  
(Font size is somehow determined relative to the screen size?)  
