# Error checking function
error_checking_output () {
   echo "  > $1"
   exit 1
}

echo ">>> Starting build and deployment for secure milk..."

# Export the classpath for the Java Servlet API
# This is required to compile specific Java Servlet code in the .java files
export CLASSPATH=/opt/tomcat/lib/servlet-api.jar
# Error check to ensure export command was sucessful
if [ ! $? -eq 0 ]; then
   error_checking_output "  > Exporting CLASSPATH failed. Exiting."
fi

# Compile each of the three .java files
javac -classpath "/opt/tomcat/lib/servlet-api.jar" ~/securemilk/WEB-INF/classes/Login.java ~/securemilk/WEB-INF/classes/Hashing.java
if [ ! $? -eq 0 ]; then
   error_checking_output "  > Compiling Login.java and Hashing.java failed. Exiting."
fi
javac -classpath "/opt/tomcat/lib/servlet-api.jar" ~/securemilk/WEB-INF/classes/Noticeboard.java
if [ ! $? -eq 0 ]; then
   error_checking_output "  > Compiling Noticeboard.java failed. Exiting."
fi

# Make sure we are in the web app root directory
echo "  > Entering web app root directory"
cd ~/securemilk

# Create a .war file to export to the Java Tomcat web server
# A .war file is very similar to the .jar file type
echo ">>> Creating WAR file to distribute WebApp to Tomcat"
jar -cf securemilk.war *
if [ ! $? -eq 0 ]; then
   error_checking_output "  > Creating WAR file failed. Exiting."
fi

# Copy the .war file to the Java Tomcat web server
# This will make the web application available (browsable)
echo ">>> Copying WAR file to /opt/tomcat/webapps/"
sudo cp securemilk.war /opt/tomcat/webapps/

echo ">>> Finished."
