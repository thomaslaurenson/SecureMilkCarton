echo ">>> Starting build and deployment for secure milk..."

export CLASSPATH=/opt/tomcat/lib/servlet-api.jar

javac -classpath "/opt/tomcat/lib/servlet-api.jar" ~/securemilk/WEB-INF/classes/Login.java ~/securemilk/WEB-INF/classes/Hashing.java
javac -classpath "/opt/tomcat/lib/servlet-api.jar" ~/securemilk/WEB-INF/classes/Noticeboard.java

echo "  > Entering web app root directory"
cd ~/securemilk

echo ">>> Creating WAR file to distribute WebApp to Tomcat"
jar -cf securemilk.war *

echo ">>> Copying WAR file to /opt/tomcat/webapps/"
sudo cp securemilk.war /opt/tomcat/webapps/

echo ">>> Finished."
