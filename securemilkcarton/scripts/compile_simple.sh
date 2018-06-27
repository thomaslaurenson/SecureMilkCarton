echo ">>> Starting build and deployment for secure milk carton..."

export CLASSPATH=/opt/tomcat/lib/servlet-api.jar

javac -classpath "/opt/tomcat/lib/servlet-api.jar" ~/SecureMilkCarton/securemilkcarton/WEB-INF/classes/Login.java ~/SecureMilkCarton/securemilkcarton/WEB-INF/classes/Hashing.java
javac -classpath "/opt/tomcat/lib/servlet-api.jar" ~/SecureMilkCarton/securemilkcarton/WEB-INF/classes/Noticeboard.java

echo "  > Entering web app root directory"
cd ~/SecureMilkCarton/securemilkcarton

echo ">>> Creating WAR file to distribute WebApp to Tomcat"
jar -cf securemilkcarton.war *

echo ">>> Copying WAR file to /opt/tomcat/webapps/"
sudo cp securemilkcarton.war /opt/tomcat/webapps/

echo ">>> Finished."
