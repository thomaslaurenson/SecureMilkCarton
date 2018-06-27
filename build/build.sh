# This script will setup the environment for SecureMilkCarton

# Install required packages
# default-jdk - tomcat requires Java
# curl - required for downloading files
# mysql-server - required for database
sudo apt-get --assume-yes install default-jdk curl mysql-server
if [ ! $? -eq 0 ]
then
   echo ">>> Failed package install. Exiting."
   exit 1
fi

# Work in the tmp directory
cd /tmp

# Download tomcat tarball, skip if already downloaded
if [ ! -f /tmp/apache-tomcat-8.0.52.tar.gz ]
    then
    echo ">>> File not found... Downloading."
    curl -O http://www-us.apache.org/dist/tomcat/tomcat-8/v8.0.52/bin/apache-tomcat-8.0.52.tar.gz
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
sudo tar xzvf apache-tomcat-8.0.52.tar.gz -C /opt/tomcat --strip-components=1
if [ ! $? -eq 0 ]
then
   echo "Failed tomcat extraction. Exiting."
   exit 1
fi

cd /tmp

# Download the servlet api
if [ ! -f /tmp/javax.servlet-api-3.1.0.jar ]
    then
    echo ">>> File not found... Downloading."
    curl -O http://central.maven.org/maven2/javax/servlet/javax.servlet-api/3.1.0/javax.servlet-api-3.1.0.jar
    if [ ! $? -eq 0 ]
    then
       echo ">>> Failed servlet download. Exiting."
       exit 1
    fi
else
    echo ">>> File found... Skipping download."
fi

# Copy the servlet to the correct tomcat directory
sudo mv javax.servlet-api-3.1.0.jar /opt/tomcat/lib/servlet-api.jar
if [ ! $? -eq 0 ]
then
   echo "Failed servlet copy. Exiting."
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

# Download the service file
if [ ! -f /etc/systemd/system/tomcat.service ]
    then
    echo ">>> File not found... Downloading."
    sudo cp ~/SecureMilkCarton/build/tomcat.service /etc/systemd/system/
    if [ ! $? -eq 0 ]
    then
       echo ">>> Failed service download. Exiting."
       exit 1
    fi
else
    echo ">>> File found... Skipping download."
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

# Change to home directory
cd ~

# Move to the securemilkcarton database directory
cd ~/SecureMilkCarton/securemilkcarton/database

# Set appropriate permissions
chmod u+x create_db.sh
chmod u+x recreate_db.sh

# Create the database
./create_db.sh

# Move to the securemilkcarton scripts directory
cd ~/SecureMilkCarton/securemilkcarton/scripts

# Set appropriate permissions
chmod u+x compile.sh

# Run the compilation script
sudo ./compile.sh