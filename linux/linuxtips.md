# Tips for Linux

## Table of Contents
<!-- vim-markdown-toc GFM -->

* [Proxy](#proxy)
  * [curl](#curl)
  * [apt-get](#apt-get)
  * [yum](#yum)
  * [pip/easy_install](#pipeasy_install)
* [User](#user)
  * [Add user to sudoers](#add-user-to-sudoers)
* [Networking](#networking)
  * [Assign static IP address](#assign-static-ip-address)
* [CLI only mode](#cli-only-mode)
  * [Increase font size](#increase-font-size)
  * [Supperss visual bell](#supperss-visual-bell)
  * [Increase command line width](#increase-command-line-width)
  * [Copy and paste text on console](#copy-and-paste-text-on-console)
* [Ubuntu](#ubuntu)
  * [Change timezone](#change-timezone)
* [CentOS](#centos)
  * [Update package management cached](#update-package-management-cached)
* [Xubuntu](#xubuntu)
  * [Execute script after logout](#execute-script-after-logout)
  * [Add startup application](#add-startup-application)
* [GUI](#gui)
  * [Switch between with and without GUI](#switch-between-with-and-without-gui)
    * [Change default setting (start up with or whithout GUI)](#change-default-setting-start-up-with-or-whithout-gui)
    * [Start and kill X on demand](#start-and-kill-x-on-demand)
  * [Change the directory path for Gui (Desktop, Downloads, Music and etc)](#change-the-directory-path-for-gui-desktop-downloads-music-and-etc)

<!-- vim-markdown-toc -->

## Proxy
<mark>NOTE</mark> <span>Use URL encoding for special characters (e.g. %20 for Spaces)</span>  

Setting environment variable as below generally works.
```sh
export http_proxy='http://[<user>:<password>]@<proxyhost>[:<port>]'
export https_proxy='https://[<user>:<password>]@<proxyhost>[:<port>]'
```
However, for commands that requires `sudo`, since `sudo` will be executed in not sub-session but
totally separate session (_this is my guess, citation necessary_), use `sudo -E`.  
(`-E` option preserve environment of the current session)  
### curl
Use option  
```sh
# -x or --proxy
curl -x 'http[s]://[<user>:<password>]@<proxyhost>[:<port>]'
```

### apt-get
```aptconf
# add below to /etc/apt/apt.conf
Acquire::http::Proxy "http://[<user>:<password>]@<proxyhost>[:<port>]";
Acquire::https::Proxy "https://[<user>:<password>]@<proxyhost>[:<port>]";
```

### yum
```ini
# add below to /etc/yum.conf
[main]
------
proxy=http://<Proxy-Server-IP-Address>:<Proxy_Port>
proxy_username=<Proxy-User-Name>
proxy_password=<Proxy-Password>
------
```

### pip/easy_install
Same as [curl](#curl)  
(On Ubuntu, `--proxy` option does not work apparently.)  

## User
### Add user to sudoers  
`usermod -aG wheel username`


## Networking
### Assign static IP address  
Edit `/etc/sysconfig/network-scripts/ifcfg-*interface name`  

Reference:  
- [11.1 About Network Interfaces](https://docs.oracle.com/cd/E37670_01/E41138/html/ol_about_netconf.html)  
- [FAQ/CentOS6 - CentOS Wiki](https://wiki.centos.org/FAQ/CentOS6)  
- [13.2. Interface Configuration Files](https://www.centos.org/docs/5/html/Deployment_Guide-en-US/s1-networkscripts-interfaces.html)  


## CLI only mode
### Increase font size
Run `setfont <font>`  
Available fonts and my favorite font for each OS are:

|   OS   |          Path         | Favorite |
|:------:|:---------------------:|:--------:|
| CentOS | /lib/kbd/consolefonts | sun12x22 |

In `.bashrc`, add the code below as `$TERM` is *linux* while cygwin via ssh access is *xterm*.  
```sh
if [[ $TERM = "linux" ]]; then
  setfont <font>
fi
```

### Supperss visual bell
`set bell-style none`  
(executing on the command line does not work but putting in inputrc does)  

### Increase command line width
<mark>NOTE</mark> <span style="color: ">This might differ in OS other than CentOS</span>  
- Open `/etc/default/grub` and add `vga=791` to `GRUB_CMDLINE_LINUX`  
  (791 means 1024x768x16. This is the largest resolution supported)  
- Run `grub2-mkconfig -o /boot/grub2/grub.cfg` (make sure to backup original cfg file with `cp -a`)  
- Reboot  

### Copy and paste text on console
use `screen` command  

## Ubuntu
### Change timezone
```sh
# change
sudo timedatectl set-timezone <time-zone>
# list possible time zone options
timedatectl list-timezones
```

## CentOS
### Update package management cached
`yum makecache fast`  

## Xubuntu
### Execute script after logout
<mark>NOTE</mark> <span style="color: ">Not before the logout so that controlling application cannot be done via this method</span>
1. write a script which you want to be executed
1. add "session-cleanup-script=/path/to/script" to the below
1. /etc/xdg/xdg-xubuntu/lightdm/lightdm-gtk-greeter.conf
<source>
http://askubuntu.com/questions/293312/execute-a-script-upon-logout-reboot-shutdown-in-ubuntu

### Add startup application
1. add application to /etc/xdg/autostart/
2. Add an initscript.
Create a new script in /etc/init.d/myscript


[Reference](http://askubuntu.com/questions/228304/how-do-i-run-a-script-at-start-up)


## GUI
<mark>NOTE</mark> <span style="color: ">The below is all for CentOS. Path and commands might
differ in other OS</span>  
### Switch between with and without GUI
#### Change default setting (start up with or whithout GUI)
`systemctl get-default` (get current mode)  
`systemctl set-default multi-user.target` (no gui)  
`systemctl set-default graphical.target` (with gui)  

Reference: [How to boot CentOS 7 into Command Line or GUI Mode | The WP
Guru](https://wpguru.co.uk/2016/11/how-to-boot-centos-7-into-command-line-or-gui-mode/)

#### Start and kill X on demand
(If this does not work, you need display manager such as kdm)
- Start  
  `echo "exec <Desktop Environment>" >> ~/.xinitrc`  
  `startx`  
  Desktop Environment:
  - gnome-session (Gnome 3)
  - startkde
  - /usr/bin/xxx-session
- Stop  
  <span style="color: red">Do not go back to 1st workspace after doing these as it gets stuck.</span>
  - Press `Ctrl + Alt + F2` (enter cli in 2nd workspace)  
  - `service gdm status` (check if gnome is running)  
  - `service gdm stop` (stop GUI)  
  - `ps -e | grep gnome` (check if gnome process is running)  

    Reference:  
- [gui - How to install Desktop Environments on CentOS 7? - Unix & Linux Stack Exchange
  ](http://unix.stackexchange.com/questions/181503/how-to-install-desktop-environments-on-centos-7)  
- [linux - CentOS 7 how to stop / start Gnome desktop from command line - Stack Overflow
  ](http://stackoverflow.com/questions/39012285/centos-7-how-to-stop-start-gnome-desktop-from-command-line)  
- For KDE: [Restart KDE Plasma Without Rebooting the Computer](https://www.lifewire.com/kubuntu-p2-2202573)


### Change the directory path for Gui (Desktop, Downloads, Music and etc)
Edit `~/.config/user-dirs.dirs`  
Example:  
```sh
XDG_DESKTOP_DIR="$HOME/guidirs/Desktop"
XDG_DOWNLOAD_DIR="$HOME/guidirs/Downloads"
XDG_TEMPLATES_DIR="$HOME/guidirs/Templates"
XDG_PUBLICSHARE_DIR="$HOME/guidirs/Public"
XDG_DOCUMENTS_DIR="$HOME/guidirs/Documents"
XDG_MUSIC_DIR="$HOME/guidirs/Music"
XDG_PICTURES_DIR="$HOME/guidirs/Pictures"
XDG_VIDEOS_DIR="$HOME/guidirs/Videos"
```
