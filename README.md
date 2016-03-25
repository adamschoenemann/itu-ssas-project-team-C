# ITU SASS Project, Team C
This is the project for System Architecture and Security at ITU

## Developing on local machine without Eclipse
Its not particularly easy, but its doable!

Steps:

1. Download and install Tomcat.
	- NB! It MUST be version 7.0.12. ANY OTHER VERSION WILL NOT WORK WITH THIS CODE.
2. Download and install Ant, if you do not already have it
3. Download the JDBC MySQL connector drivers. It MUST be version 5.1.28
	- Here is the link! [MySQL connector][1]
4. Put the MySQL connector driver jar in %TOMCAT_INSTALL%/lib
5. Copy the following files from %TOMCAT_INSTALL%/lib to %ANT_INSTALL%/lib
	- catalina-ant.jar
	- tomcat-coyote.jar
	- tomcat-util.jar
6. In this repository's root, create a file called `build.properties`.
   Copy the following into it, replacing the necessary variables.

```
app.path=/ssas # where you the app to be hosted
catalina.home=F:/Dropbox/Programs/tomcat/apache-tomcat-7.0.12 # path to your tomcat install
web.home=${basedir}/WebContent # keep this
	
manager.username=admin # your manager username
manager.password=password # your manager's password
```

7. If you have set up a manager user for tomcat, you should be almost ready now!
8. Start or restart tomcat
9. cd into this directory
10. run `ant all`
	- this will compile a bunch of classes - hopefully it succeeds!
11. run `ant install`
	- this will copy the contents of the build/ directory to %TOMCAT_INSTALL%/webapps/ssas, where the last piece depends on your build.properties.
12. Open your browser and navigate to localhost:8080/ssas and you should see the webapp!
13. Make a change in some .jsp or java file whatever
14. run `ant redeploy` to update the /webapp dir with your newest changes
15. Enjoy not using Eclipse and the VM provided!

[1]: http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.28/mysql-connector-java-5.1.28.jar
