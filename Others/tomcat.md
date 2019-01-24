## Tomcat

### Setup
1. Create "setenv.bat" unser $CATALINA_HOME/bin  
	1. set JAVA_HOME or JRE_HOME (required) to the JDK (JRE) directory  
		example: `set JAVA_HOME=%ProgramFiles%\Java\jdk1.8.0_121\`  
		With JRE_HOME, either JRE or JDK directory is fine while only JDK directory is acceptable.  
		This is because Tomcat checks for JDK availability to ensure JDK option will not fail.  
	2. set CATALINA_OPTS or JAVA_OPTS  
		It is JVM parameter. The difference between those two is effective to tomcat only on one hand
		(CATALINA_OPTS) and applicable to all java application on the other hand (JAVA_OPTS).  
		example: `set JAVA_OPTS=%JAVA_OPTS% -Xms256m -Xmx1024m -XX:MaxMetaspaceSize=256m
		-XX:+UseParallelOldGC`  

### Usage
* **Start tomcat**  
Run startup.bat/sh under bin  
* **Stop tomcat**  
Run shotdown.bat/sh under bin  

### Logging
Logs are stored in $CATALINA_HOME/logs  
* localhost_access_log.yyyy-mm-dd.txt  
  Access info (GET/POST etc) is logged here  
* catalina.yyyy-mm-dd.log  
  Server's log is logged here  
* catalina.out  
  Console output is logged here  

### Misc
When Tomcat project(?) is created, Tomcat creates xml file with the same name as the project.  
Path: [CATALINA_HOME]/conf/Catalina/localhost/*Project_name*.xml  
When the project is renamed, it doesn't modify the xml file, so the xml file needs to be modified manually.

### Configuration
#### Request forwarding
Web server cannot handle requests for dynamic contents, and those need to be forwarded to
application server or servlet container.  
Web server does not have the capability to do that so a plugin (web server adapter) needs to be
installed.([^1])  
With that plugin (mod_jk), Web server now refers to files to determine which requests to forward, and those
files are httpd.conf\* (for CentOS, at least) and server.xml.([^2])  
\* To determine the file name and the location, run the commands below:  
```sh
# find the httpd binary apache (tomcat?) uses
ps -fu apache
--- sample output ---
UID         PID   PPID  C STIME TTY          TIME CMD
apache     1165   1063  0 15:29 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
---------------------

# get the config file path
/usr/sbin/httpd -V | grep SERVER_CONFIG_FILE
--- sample output ---
 -D SERVER_CONFIG_FILE="conf/httpd.conf"
---------------------

# if the file path is relative, prepend the value of the below command to the path
/usr/sbin/httpd -V | grep HTTPD_ROOT
--- sample output ---
 -D HTTPD_ROOT="/etc/httpd"
---------------------
```

<!-- Reference -->
[^1]:http://www.theserverside.com/feature/Understanding-How-the-Application-Servers-Web-Container-Works
[^2]:https://tomcat.apache.org/tomcat-3.2-doc/tomcat-apache-howto.html

#### HTTPS connection
<span style="color: red">This didn't succeed. Because SSL certification is lacking? No
implementation of the protocol?</span>  

**Key generation and Configuring server.xml**  
https://www.mkyong.com/tomcat/how-to-configure-tomcat-to-support-ssl-or-https/  
(Attribute for key's password is **certificateKeystorePassword=**, though the website states
otherwise.)  

**Location of server.xml on eclipse**  
In the Project Explorer, Servers -> *Tomcat server name* -> server.xml  
https://stackoverflow.com/questions/951890/eclipse-wtp-how-do-i-enable-ssl-on-tomcat  
