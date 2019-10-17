## Basic
### Shutdown the vm
`wsl.exe --shutdown`

### Startup Configuration
You can configure things like mount path, network and inter-operability by  
editing (or create) `/etc/wsl.conf`.  
Refer to [this page](https://docs.microsoft.com/en-us/windows/wsl/wsl-config#set-wsl-launch-settings) for more detail.

## SSH
- IP address is either `127.0.0.1` or one under `eth0` of `ip addr` output.
- Change `PasswordAuthentication` to `yes` if you want to ssh with password.

## Issues
- docker deamon runs but cannot build images
- qutebrowser crashes
