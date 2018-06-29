# Error checking function
error_checking_output () {
   echo "  > $1"
   exit 1
}

# Move the the script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
cd ..

echo ">>> Working directory: `pwd`"

echo ">>> Starting build and deployment for secure milk carton..."

# Compile each of the three .java files
sudo javac -classpath WEB-INF/lib/servlet-api.jar WEB-INF/classes/Login.java WEB-INF/classes/Hashing.java
if [ ! $? -eq 0 ]; then
   error_checking_output "  > Compiling Login.java and Hashing.java failed. Exiting."
fi
sudo javac -classpath WEB-INF/lib/servlet-api.jar WEB-INF/classes/Noticeboard.java
if [ ! $? -eq 0 ]; then
   error_checking_output "  > Compiling Noticeboard.java failed. Exiting."
fi

# Create a .war file to export to the Java Tomcat web server
# A .war file is very similar to the .jar file type
echo ">>> Creating WAR file to distribute WebApp to Tomcat"
sudo jar -cf securemilkcarton.war *
if [ ! $? -eq 0 ]; then
   error_checking_output "  > Creating WAR file failed. Exiting."
fi

# Copy the .war file to the Java Tomcat web server
# This will make the web application available (browsable)
echo ">>> Copying WAR file to /opt/tomcat/webapps/"
sudo cp securemilkcarton.war /opt/tomcat/webapps/

echo ">>> Finished."
