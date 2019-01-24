# VMWare

## Installation
### CentOS
#### Disable Easy Install  
Select `install OS later` or something like that  
(As of 27/07/2018 (version 1804) this option is not present)  

#### User
- Check `Make this user administrator` to add the user to sudoers (the user will be able to `sudo`)

## Configuration
### Common
#### Internet not connected  
It was probably because I changed setting for internet duraing installation  

#### Internet connection was disabled on NAT connection...  
Don't know why but after pressing "Restore default" on vmnetcfg, it works fine  

#### Assign static IP to guests on NAT connection  
<mark>NOTE</mark> <span style="color: ">No need to shutdown running guests</span>  
1. On virtual network magager, select NAT network and check `Use local DHCP service to ...`  
2. Edit *C:\ProgramData\VMware\vmnetdhcp.conf* (on windows).  
  The below is an example.  
  ```
  host CentOS64-bit { # This is virtual machine name shown in the option tab in Virtual Machine
  Setting without any whitespaces
      hardware ethernet 00:0C:29:DC:B8:41;
      fixed-address 192.168.153.100;
  }
  ```
3. Restart the VMware DHCP service  
  ```
  net stop vmnetdhcp
  net start vmnetdhcp
  ```
4. If the ip address of guest is not changed, run the command below (on linux guest)  
   `sudo dhclient`  

## Misc
### Copy and paste across host and guest system
For GUI guest, install `VMware Tools`.  
For CLI guest, `ssh` to it and do some work.  
(Ref: http://www.thomasmaurer.ch/2016/04/using-ssh-with-powershell/, or simply use Cygwin)  

