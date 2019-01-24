## Use US keyboard
Reference: http://blog.heiichi.com/?eid=792239
1. Launch registry editor
2. Go to *HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters*
3. Modify the value of *LayerDriver JPN* from *kbd106.dll* to *kbd101.dll*
4. Modify the value of *OverrideKeyboardIdentifier* from *PCAT_106KEY* to *PCAT_101KEY*
5. Modify the value of *OverrideKeyboardSubtype* from *2* to *0*
6. Reboot the PC
