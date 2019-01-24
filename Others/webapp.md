### Where to place jar file (such as JDBC connector)
If there is no file under `WEB-INF/lib` directory, then the server's default lib is used.  
(In case of Tomcat, jar file is stored under $CATALINA_HOME/lib)  
If files exist under `WEB-INF/lib`, ONLY those files are used, so default lib such as
`servlet-api.jar` will be unavailable, then classes like HttpServletRequest will be unavailable.  
To solve this, simply move the necessary jar into `WEB-INF/lib`.

