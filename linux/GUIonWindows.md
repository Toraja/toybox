# GUI on Windows

## Requirements
- VcXsrv (display server for windows)

## Procedure
1. Install VcXsrv on windows
1. Run VcXsrv (installed as XLaunch)
  - VcXsrv will listen on port 6000 by default
  - Allow public network on firewall setting  
    Tried [this config](https://skeptric.com/wsl2-xserver/) which does not
    require public network but could not make it work...
  - Check `Disable access control` on Extra setting page  
    or authentication will be required
  - Save config and put the config in start up folder.  
    To open start up folder, press `Win + R` and enter `shell:startup`.
1. Get ip address of windows machine
  - WSL 1: `localhost`
  - WSL 2: `nameserver` in `/etc/resolv.conf` or IP address under `Ethernet adapter vEthernet (WSL)` of `ipconfig`
  - vmware: host's IP for `bridge`, gateway(?) for `NAT`
1. set Env on linux machine as in `export DISPLAY=<windows IP>:0.0`
  - Trailing `0.0` does not need to be changed  
    unless you are using multiple display (multiple display server?)
  - The first number (left to the dot) changes the port number VcXsrv listens to.
1. Run GUI app on linux machine (can be via ssh)
