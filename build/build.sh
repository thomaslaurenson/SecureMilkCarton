# This script will setup the environment for SecureMilkCarton

# Move the the script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Install required packages
# default-jdk - Apache Tomcat requires Java
# curl - required for downloading files
sudo apt-get --assume-yes install default-jdk curl
if [ ! $? -eq 0 ]
then
   echo ">>> Failed initial package install. Exiting."
   exit 1
fi

# mysql-server - required for database
sudo apt-get install mysql-server
if [ ! $? -eq 0 ]
then
   echo ">>> Failed mysql install. Exiting."
   exit 1
fi

# Work in the tmp directory
cd /tmp

# Download tomcat tarball, skip if already downloaded
if [ ! -f /tmp/apache-tomcat-8.0.53.tar.gz ]
    then
    echo ">>> File not found... Downloading."
    curl -O https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.53/bin/apache-tomcat-8.0.53.tar.gz
    if [ ! $? -eq 0 ]
    then
       echo ">>> Failed tomcat download. Exiting."
       exit 1
    fi
else
    echo ">>> File found... Skipping download."
fi

# Create /opt/tomcat directory for installation
if [ ! -d /opt/tomcat ]
    then
    sudo mkdir /opt/tomcat
    if [ ! $? -eq 0 ]
    then
        echo "Failed mkdir /opt/tomcat. Exiting."
        exit 1
    fi
else
    echo ">>> Directory found... Skipping creation."
fi

# Extract tomcat to /opt/tomcat
sudo tar xzvf apache-tomcat-8.0.53.tar.gz -C /opt/tomcat --strip-components=1
if [ ! $? -eq 0 ]
then
   echo "Failed tomcat extraction. Exiting."
   exit 1
fi

# Make a group called tomcat
groupname="tomcat"
if grep -q $groupname /etc/group
    then
    echo ">>> Group exists... Continuing."
else
    echo ">>> Group does not exists... Making group."
    sudo groupadd tomcat
    if [ ! $? -eq 0 ]
    then
       echo "Failed groupadd tomcat. Exiting."
       exit 1
    fi
fi

# Make a user called tomcat
username="tomcat"
if grep -q $username /etc/passwd
    then
    echo ">>> User exists... Continuing."
else
    echo ">>> User does not exists... Making user."
    sudo useradd -s /bin/false -g $username -d /opt/$username $username
    if [ ! $? -eq 0 ]
    then
       echo "Failed useradd tomcat. Exiting."
       exit 1
    fi
fi

# Ownership: recursive tomcat for /opt/tomcat
sudo chgrp -R tomcat /opt/tomcat
if [ ! $? -eq 0 ]
then
   echo "Failed /opt/tomcat group ownership. Exiting."
   exit 1
fi

cd /opt/tomcat/

# Ownership: recursive tomcat for /opt/tomcat/conf
sudo chmod -R g+r conf
if [ ! $? -eq 0 ]
then
   echo "Failed /opt/tomcat/conf group ownership. Exiting."
   exit 1
fi
    
# Ownership: tomcat for /opt/tomcat/conf folder
sudo chmod g+x conf
if [ ! $? -eq 0 ]
then
   echo "Failed /opt/tomcat/conf group ownership (folder). Exiting."
   exit 1
fi

# Ownership: tomcat user for /opt/tomcat folders
sudo chown -R tomcat webapps/ work/ temp/ logs/
if [ ! $? -eq 0 ]
then
   echo "Failed tomcat user for /opt/tomcat folders. Exiting."
   exit 1
fi

# Ownership: logged in user for /opt/tomcat folders
sudo chown -R `whoami` webapps/ work/ temp/ logs/
if [ ! $? -eq 0 ]
then
   echo "Failed ownership change for /opt/tomcat folders. Exiting."
   exit 1
fi

# Ownership: Group write for /opt/tomcat
sudo chmod -R g+w /opt/tomcat 
if [ ! $? -eq 0 ]
then
   echo "Group write for /opt/tomcat. Exiting."
   exit 1
fi

# Only for checking java version
#sudo update-java-alternatives -l

cd /tmp

# Create service file for Apache Tomcat
touch tomcat.service
echo "[Unit]" >> tomcat.service
echo "Description=Apache Tomcat Web Application Container" >> tomcat.service
echo "After=network.target" >> tomcat.service
echo "[Service]" >> tomcat.service
echo "Type=forking" >> tomcat.service
echo "Environment=JAVA_HOME=`sudo update-java-alternatives -l | awk '{print $3}'`"
echo "Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid" >> tomcat.service
echo "Environment=CATALINA_HOME=/opt/tomcat" >> tomcat.service
echo "Environment=CATALINA_BASE=/opt/tomcat" >> tomcat.service
echo "Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'" >> tomcat.service
echo "Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'" >> tomcat.service
echo "ExecStart=/opt/tomcat/bin/startup.sh" >> tomcat.service
echo "ExecStop=/opt/tomcat/bin/shutdown.sh" >> tomcat.service
echo "User=tomcat" >> tomcat.service
echo "Group=tomcat" >> tomcat.service
echo "UMask=0007" >> tomcat.service
echo "RestartSec=10" >> tomcat.service
echo "Restart=always" >> tomcat.service
echo "[Install]" >> tomcat.service
echo "WantedBy=multi-user.target" >> tomcat.service

sudo cp tomcat.service /etc/systemd/system/
if [ ! $? -eq 0 ]
then
    echo ">>> Failed moving tomcat.service file. Exiting."
    exit 1
fi

sudo chmod 755 /etc/systemd/system/tomcat.service

# Reload all service daemons
sudo systemctl daemon-reload

# Start the tomcat service
sudo systemctl start tomcat

# Enable the tomcat service at boot
sudo systemctl enable tomcat
 
# Set up a secure installation of MySQL
# See: https://stackoverflow.com/a/36916378
# sudo mysql_secure_installation <<EOF

# y
# passw0rd
# passw0rd
# y
# y
# y
# y
# EOF
# Can set it to manual, just use the command:
#sudo mysql_secure_installation

# Change to build script directory
cd $DIR
cd ../securemilkcarton/scripts/

# Set appropriate permissions
chmod u+x create_db.sh
chmod u+x recreate_db.sh

# Create the database
./create_db.sh

# Set appropriate permissions
chmod u+x compile.sh

# Run the compilation script
sudo ./compile.sh
