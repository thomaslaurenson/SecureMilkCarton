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

echo ">>> Finished."
