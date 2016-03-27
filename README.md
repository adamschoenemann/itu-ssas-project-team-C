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


## Running the deployment machine

The deploymemt mackine needs at least two (virtual) network cards, the second
must be on the InfSec internal network. This is set up with static ip
address 192.168.0.101.

For convenience you can set up the machine mu (Sørens template) with a second
network card on the InfSec internal network. It needs to have a static
ip address as well (I have set up mine as 192.168.0.100). For further
convenience add the line below to /etc/hosts on mu:
192.168.0.101	photoshare

Now you can reach the deployment machine as "photoshare". Verify with
ping photoshare.

The project web application (in all its insecure glory) is running
on port 443. Access with https://photoshare (you will need to accept the
self signed certificate). The regular http port (80) should redirect
you to https.

There is one regular user on the machine. You can log on ssh from mu
(more convenient than logging on via the machine itself as it does not
have a graphical UI).
Use name: photoshare
Password: ssas16teamC

For work on the db or the OS/config you will have to log onto the machine.
To just deploy a new WAR file, see below.


## Deploying to the deployment machine

1. Build/export the WAR file to deploy.
   Preferably put it in $HOME/dk.itu.ssas.project.war
2. The deployment machine must be up and running and the local machine
   must be on the "InfSec" internal network as well
3. Run the script ./deploy.sh from this directory.
4. You will be asked for the password for the key photoshare_rsa.
   The password is: ssas16teamC
5. Voilá - deployed. In case of trouble look in the deploy.sh script
   for answers...
