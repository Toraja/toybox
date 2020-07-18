# Maven

## How to filter files
1. Prepare filter properties for each environment  
   (i.e. files in which variables and values for the environment are defined)  
2. Add where filter properties are stored to pom.xml  
   e.g.
   ```xml
   <build>
     <filters>
       <!-- Ensures that the filter.properties file is always loaded from 
         the configuration directory of the active Maven profile. -->
       <filter>filters/${build.profile.id}/filter.properties</filter>
     </filters>
   </build>
   ```
3. If it is defined in pom.xml to add directories to classpath, add filter tag to it.  
   (Example is show in *Add directories to classpath* section)  
   (**src/main/resources** and **src/test/resources** seem to be filtered by default.)  
4. Run maven compile  

## Add directories to classpath
The below is an example of adding directories for IT.  
After modifying pom.xml, right click the project -> *Maven* -> *Update Project*  
It should create directories but create manually if not.  

```xml
<plugin>
  <groupId>org.codehaus.mojo</groupId>
  <artifactId>build-helper-maven-plugin</artifactId>
  <version>3.0.0</version>
  <executions>
    <!-- Add a new source directory to our build -->
    <execution>
      <id>add-integration-test-sources</id>
      <phase>generate-test-sources</phase>
      <goals>
        <goal>add-test-source</goal>
      </goals>
      <configuration>
        <!-- Configures the source directory of our integration tests -->
        <sources>
          <source>src/it/java</source>
        </sources>
      </configuration>
    </execution>
    <!-- Add a new resource directory to our build -->
    <execution>
      <id>add-integration-test-resources</id>
      <phase>generate-test-resources</phase>
      <goals>
        <goal>add-test-resource</goal>
      </goals>
      <configuration>
        <!-- Configures the resource directory of our integration tests -->
        <resources>
          <!-- Placeholders that are found in the files located in 
            the configured resource directories are replaced with the property values 
            found in the profile specific configuration file. -->
          <resource>
            <filtering>true</filtering>
            <directory>src/it/resources</directory>
          </resource>
        </resources>
      </configuration>
    </execution>
  </executions>
</plugin>
```

## Separate Unit test and Integration test
What you need to do is:
1. Define profile for each environment in pom.xml
2. Add *maven-surefire-plugin* and *maven-failsafe-plugin*  
   e.g.
   ```xml
   <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-surefire-plugin</artifactId>
        <version>2.20</version>
        <configuration>
          <!-- Skips unit tests if the value of skip.unit.tests property 
            is true -->
          <skipTests>${skip.unit.tests}</skipTests>
          <!-- Excludes integration tests when unit tests are run -->
          <excludes>
            <exclude>**/IT*.java</exclude>
          </excludes>
        </configuration>
      </plugin>

      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-failsafe-plugin</artifactId>
        <version>2.20</version>
        <executions>
          <!-- Invokes both the integration-test and the verify goals of 
            the Failsafe Maven plugin -->
          <execution>
            <id>integration-tests</id>
            <goals>
              <goal>integration-test</goal>
              <goal>verify</goal>
            </goals>
            <configuration>
              <!-- Skips integration tests if the value of skip.integration.tests 
                property is true -->
              <skipTests>${skip.integration.tests}</skipTests>
            </configuration>
          </execution>
        </executions>
      </plugin>
      ```

## Run
### Default
Maven can be executed from *Run* -> *Run As* -> [Maven Option]  
Options are:  
* Maven build (With keyboard shortcut)  
  Choose one of Run Configurations and that will run  
* Maven build (Without keyboard shortcut)  
  ?  
* Maven clean  
  Delete built materials (usually target directory)  
* Maven generate-sources  
  ?  
* Maven install  
  ?  
* Maven test  
  Run active test  

### Run Configuration
Run maven with specified goals and profile  
* Integration test  
  Put *integration-test* and *verify* in goals  
  Without *verify*, build will succeed even when test has failed  
* Compile and create war  
  Put *compile* and *package* in goals  
  *clean* may be put before those (any problem without *clean*?)  
  war (or the archive type specifed in *packaging* tag) file is output under target directory by default  

## Webapp
To filter frontend materials, add below to pom.xml.  
```xml
<plugin>
  <artifactId>maven-war-plugin</artifactId>
  <version>3.1.0</version>
  <configuration>
    <webResources>
      <resource>
        <directory>src/main/webapp</directory>
        <filtering>true</filtering>
      </resource>
    </webResources>
  </configuration>
</plugin>
```
The folder structure under webapp is:  
```
webapp
|-- css
|-- js
|-- META-INF
`-- WEB-INF
```
Test resources should be placed in src/test/webapp.  

To exclude materials from packaging, add below to pom.xml.  
(Is it possible to filter materials but not including in war using the tag below?)  
(In that case, where would the filtered file be output?)  

```xml
<configuration>
  <warSourceExcludes>*path to directory*</warSourceExcludes>
</configuration>
```

## Note
When maven complains that **No compiler is provided**  
http://roufid.com/no-compiler-is-provided-in-this-environment/

## Source
How to separate UT and IT  
[Integration Testing With Maven
](https://www.petrikainulainen.net/programming/maven/integration-testing-with-maven/)
