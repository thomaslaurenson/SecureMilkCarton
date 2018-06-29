echo ">>> Starting build and deployment for secure milk carton..."

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
cd ..

echo ">>> Working directory: `pwd`"

sudo javac -classpath WEB-INF/lib/servlet-api.jar WEB-INF/classes/Login.java WEB-INF/classes/Hashing.java
sudo javac -classpath WEB-INF/lib/servlet-api.jar WEB-INF/classes/Noticeboard.java

echo ">>> Creating WAR file to distribute WebApp to Tomcat"
sudo jar -cf securemilkcarton.war *

echo ">>> Copying WAR file to /opt/tomcat/webapps/"
sudo cp securemilkcarton.war /opt/tomcat/webapps/

echo ">>> Finished."
