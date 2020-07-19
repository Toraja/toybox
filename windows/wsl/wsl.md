## Basic
### Shutdown the vm
`wsl.exe --shutdown`

## Configuration
### Startup
You can configure things like mount path, network and inter-operability by  
editing (or create) `/etc/wsl.conf`.  
Refer to [this page](https://docs.microsoft.com/en-us/windows/wsl/wsl-config#set-wsl-launch-settings) for more detail.

### Spec
Memory, the number of processors, swap size and etc can be configured by editing
(or creating) `~/.wslconfig` on windows.  
Refer to [this page](https://www.bleepingcomputer.com/news/microsoft/windows-10-wsl2-now-allows-you-to-configure-global-options/) for more detail.

## SSH
- IP address is either `127.0.0.1` or one under `eth0` of `ip addr` output.
- Change `PasswordAuthentication` to `yes` if you want to ssh with password.

## Issues
- qutebrowser crashes
