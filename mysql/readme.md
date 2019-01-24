# How to MySQL

<!-- TOC depthFrom:2 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Setup](#setup)
	- [Windows (zip archive)](#windows-zip-archive)
	- [Linux (Zip archive)](#linux-zip-archive)
	- [Linux (install from repository)](#linux-install-from-repository)
- [Option File](#option-file)
- [Note](#note)
	- [Access MySQL server 8.0 or above from older client](#access-mysql-server-80-or-above-from-older-client)
- [Usage](#usage)
	- [Startup / Shutdown](#startup-shutdown)
	- [Useful Options](#useful-options)
	- [SQL Command reference](#sql-command-reference)

<!-- /TOC -->

## Setup

### Windows (zip archive)
1. Place uncompressed mysql directory to a location you like. (the conventional directory name is "mysql")
2. Create an option file ("my.ini" or "my.cnf") and place it under the above directory.  
	Refer to [Option File](#option-file) for the detail.

3. Initialize the mysql data directory by running `mysqld.exe --initialize` or
`mysqld.exe --initialize-insecure` (you can login as _root_ without password)  
	(You might need to create the *datadir* specified in No.2 first.)
4. Check if the directory contents exist.

### Linux (Zip archive)
After installing mysql, option files should be present in **/etc/mysql**.  
To set user specific option, create **~/my.cnf**.  
<mark>TODO</mark> <span style="color: green">/var/run issue</span>  
On every login, folders created in /var/run (/run) is removed and contents in the direcotry are
reverted back to default.  
Script under /etc/init.d, /etc/init or /usr/lib/tmpfiles.d is not run?  
(files under init/init.d are created by someone (apt-get?) and under tmpfiles.d are by me)  
*[Reference]  
[linux - What's removing stuff from /var/run at reboots from a fedora machine? - Server Fault][1]  
[boot - How folders created in /var/run on each reboot - Ask Ubuntu][2]  
[linux screen script in init.d not running - Google Search][3]  
[ubuntu - init.d script not being run on boot - Unix & Linux Stack Exchange][4]*  

[1]:http://serverfault.com/questions/546966/whats-removing-stuff-from-var-run-at-reboots-from-a-fedora-machine
[2]:http://askubuntu.com/questions/303120/how-folders-created-in-var-run-on-each-reboot
[3]:https://www.google.com/search?client=ubuntu&channel=fs&q=linux+screen+script+in+init.d+not+running&ie=utf-8&oe=utf-8
[4]:http://serverfault.com/questions/546966/whats-removing-stuff-from-var-run-at-reboots-from-a-fedora-machine

Starting MySQL server with sudo or causes "Permission denied" error.  
(Configuring in option file and set all the required direcories to non-privileged directories might
solve the problem, but doing so seems not so simple.)

Sometimes, mysqld cannot be started even though /var/run/mysqld does exist.  
In such case, run mysqld_safe.  

### Linux (install from repository)
1. mysql repository can be added using rpm file (for Fedora base) which can be downloaded from mysql
   website.  
2. It seems that mysqld can only be started as service (`systemctl mysqld start` for Fedora base).  
  Hence, ~/my.cnf has no use as starting service requires root privilege.  
3. Password for root user is set and expired by default. Read the [article][11] to reset the password.  
  (To remove the password, just set the new password empty)  
4. `validate_password_policy` is set to *Medium* by default.  
  View the current value of validate_password_policy: `SHOW VARIABLES LIKE 'validate_password%';`  
  To change that, add line to /etc/my.cnf as below.  
  ```
  [mysqld]
  validate_password_policy=LOW
  ```

[11]:https://dev.mysql.com/doc/refman/5.7/en/resetting-permissions.html


## Option File
Windows: my.ini  
Linux: my.cnf
```sh
[mysqld]
# This is a must
basedir=(path to the directory created at No.1, use forward slash on windows)
# Without this, 'data' dir will be created under 'basedir' (at least on windows)
datadir=(path to the directory you want to store data, use forward slash on windows)
# without this, behaviour on timestamp column will be non-standard
explicit_defaults_for_timestamp=1
# This option limits the file path for LOAD DATA and SELECT ... INTO OUTFILE command to be inside
# the directory specified by this variable.
# If the value is relative path, the path will be relative to 'basedir'.
# Setting this variable to empty string removes the restriction of file location.
secure_file_priv="/User/Me/Data"
# allow LOAD DATA LOCAL INFILE -- i.e. loads file from client side
local-infile
# This skips attempts to set up SSL connection
skip_ssl
# specify port of server
port={port}
# Timezone of error.log is UTC by default. Add the below line to option file to sync with system time.
log_timestamps=SYSTEM
# Create multiple instance of sql server
https://dev.mysql.com/doc/refman/5.7/en/multiple-windows-services.html
# Set this option if you use client older than 8.0, as MySQL 8.0 uses caching_sha2_password for authentication
# and older clients do not support it.
default-authentication-plugin=mysql_native_password
```

## Note

### In-Memory Table
RDBMS uses memory rather than file system to store the data.  
The data of memory tables is deleted when the server shuts down.  
Simply add `ENGINE=MEMORY` to the end of `CREATE TABLE` statement.  
Example:
```sql
CREATE TABLE `emp` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `FName` varchar(20) DEFAULT NULL,
	...
  `Hobby` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
```

### Access MySQL server 8.0 or above from older client
When accessing server from client, the below error occurs.  
`ERROR 2059 (HY000): Authentication plugin 'caching_sha2_password' cannot be loaded: No such file or directory`
This is because MySQL 8.0 changed the authentication method so older client cannot access. [(^Note1)][Note1]  
To enable access from older clients, do either of those below.  
- If you have not init MySQL server with `mysqld --initialize[-insecure]`, add below line to option file and init server.  
	`default-authentication-plugin=mysql_native_password`  
- If you have already inited MySQL server, adding the option above does not affect the existing users.  
	Instead, run the below SQL command.  
  `ALTER USER '<username>'@'<ip_address>' IDENTIFIED WITH mysql_native_password BY '<password>';`

[Note1]:https://mysqlserverteam.com/upgrading-to-mysql-8-0-default-authentication-plugin-considerations/


## Usage
### Startup / Shutdown
1. start mysql server by executing `mysqld`
1. connect to mysql server by running `mysql -u root [-p {password}] [{db_name}]`  
  To access from cygwin, add `-h 127.0.0.1` to the above command  
1. shotdown mysql server by running `mysqladmin -u root shutdown`

### Useful Options
<dl>
	<dt>--console</dt>
	<dd>Output the log message to console</dd>
</dl>

### SQL Command reference
<dl>
  <dt>SELECT {column} from {table} INTO OUTFILE '{path}'</dt>
  <dt>LOAD DATA [LOCAL] INFILE '{path}' INTO TABLE {table}</dt>
  <dd>Dump the table data into a file as tsv, and load data in a file into a table.</dd>
  <dd>When <code>secure_file_priv</code> variable is set to "" (empty string), file can be output to or loaded
  from anywhere.</dd>
  <dd>When <code>secure_file_priv</code> variable is set to non-empty string, file can only be output to or
  loaded from the {path}.</dd>
  <dd>If MySQL server is running on windows, {path} can be either unix style (with forwardslash) or
  windows style (with backslash). With windows style, backslashes need to be escaped.</dd>
  <dd>If {path} is only filename, then the file will be output (and loaded? ... not tested) at the
  same location as the table data.</dd>
  <dd>i.e. <i>datadir</i>/{database name}/{path}</dd>
  <dd>To load file from client's local, <code>local-infile</code> option must be added to both
  server and client</dd>
</dl>
<dl>
  <dt>status</dt>
  <dd>display status including server's port number</dd>
</dl>
<dl>
  <dt>show {arg}</dt>
  <dd>
    <dl>
      <dt>databases</dt>
      <dd>list databases</dd>
    </dl>
    <dl>
      <dt>tables</dt>
      <dd>list tables in the database</dd>
    </dl>
    <dl>
      <dt>columns from {table name}</dt>
      <dd>show columns in the table (more options are available)</dd>
    </dl>
    <dl>
      <dt>warnings [{limit} [{offset},] {row_count}]</dt>
      <dd>display warnings</dd>
    </dl>
    <dl>
      <dt>count(\*) warnings</dt>
      <dd>display the number of warnings</dd>
    </dl>
    <dl>
      <dt>variables[ (like | where variable_name =) '{variable name}']</dt>
      <dd>list all the variable names and values (matched ones only with where/like clause)</dd>
    </dl>
		<dl>
			<dt>create table {table name}</dt>
			<dd>display the DDL for the {table name}</dd>
			<dd><code>mysqldump -d -u {user} [-p {password}] [-h {host}] {database}</code> also dumps DDL with a bit more information</dd>
		</dl>
  </dd>
</dl>
