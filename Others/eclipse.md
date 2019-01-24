#### Change eclipse's icon
1. Navigate to Eclipse's installation folder  
2. Open **eclipse.ini** and find the '-product' flag. Mine was something like this:  
```
-product
org.eclipse.epp.package.jee.product
```
3. Open the plugins folder and look for your product folder. It looks similar to your product flag.  
(mine was **org.eclipse.epp.package.jee_4.4.0.20140612-0500**)
4. All you need to do now is to replace the png files (*javaee-ide_x32.png, javaee-ide_x64.png, ...*)
with the icons that you want.
5. (Optional) In case you want to use the brand new "flatty" icon, just navigate to
plugins\org.eclipse.platform_4.4.0.v20140606-1215, copy the flat png icons and repeat the step 4.

Source: [How to change Eclipse's dock Icon · GitHub](https://gist.github.com/marlonbernardes/d3d7fd75ee689c2b989b)

#### Install plugin from zip
* If the zip contains artifact.jar and content.jar  
  *Help* >> *Install New Software* >> *Add* >> *Archive* >> select zip file  
* If not  
  place the extracted contents into a subdirectory of *dropin* direcory located in the same directory where
  *eclipse.exe* exists

#### Error
**Can't open ....jvm.cfg (or something like that)**  
Reason: JavaHome in the registry is wrong (because you changed the location of jre after
installation)  
1. Go to `\HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Runtime Environment\1.8`  
  (or version which eclipse is using)  
2. Change the value of `JavaHome` to the correct path  

