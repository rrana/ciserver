#!/bin/bash
set -e -x

#RUN THIS SCRIPT AS ROOT USER

#export DEBIAN_FRONTEND=noninteractive

# Packages
apt-get update && sudo apt-get upgrade -y
apt-get install build-essential -y

####Jenkins Part ####

#Java installation

#sudo add-apt-repository ppa:ferramroberto/java -y
#sudo apt-get update
#sudo apt-get install sun-java6-jre sun-java6-plugin sun-java6-fonts

#sudo apt-get install openjdk-6-jre-headless

echo deb http://ftp.fr.debian.org/debian/ squeeze non-free >> /etc/apt/sources.list
echo deb-src http://ftp.fr.debian.org/debian/ squeeze non-free >> /etc/apt/sources.list
apt-get update
apt-get install sun-java6-bin -y
apt-get install sun-java6-jdk -y

#Jenkins Installation
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
echo deb http://pkg.jenkins-ci.org/debian binary/ >> /etc/apt/source.list
apt-get update
apt-get install jenkins -y

#Apache installation
aptitude install libpcre3-dev libpcrecpp0 libssl-dev zlib1g-dev libgeoip-dev -y

apt-get install apache2 -y

a2enmod proxy
a2enmod proxy_http
a2enmod vhost_alias
a2dissite default

touch /etc/apache2/sites-available/jenkins
jenkins_vhost="/etc/apache2/sites-available/jenkins"
jenkins_vhost_content="<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        ServerName ci.test.com
        ServerAlias ci
        ProxyRequests Off
        <Proxy *>
                Order deny,allow
                Allow from all
        </Proxy>
        ProxyPreserveHost on
        ProxyPass / http://localhost:8080/
</VirtualHost>
"
echo "Creating jenkins_vhost file..."
echo "$jenkins_vhost_content" > $jenkins_vhost

a2ensite jenkins

/etc/init.d/apache2 stop
/etc/init.d/apache2 start

#ANT Installation
apt-get install ant

##Installation of Selenium

#XVFB Installation
apt-get install xvfb

#Unzip
apt-get install unzip

#chrome driver
cd ~
wget http://selenium.googlecode.com/files/selenium-server-2.25.0.zip
unzip selenium-server-2.25.0.zip 
cd selenium-2.25.0/

#Chrome-driver linux 32 bit: http://chromedriver.googlecode.com/files/chromedriver_linux32_23.0.1240.0.zip
#Chrome-driver linux 64 bit: http://chromedriver.googlecode.com/files/chromedriver_linux64_23.0.1240.0.zip

cd ~
wget http://chromedriver.googlecode.com/files/chromedriver_linux64_23.0.1240.0.zip
unzip chromedriver_linux64_23.0.1240.0.zip
cp chromedriver /usr/local/bin/
chmod a+x /usr/local/bin/chromedriver
#You can test chrome driver by runnin: chromedriver in your terminal

apt-get install lo-menubar
#apt-get install ImageMagick
apt-get install graphviz

apt-get install -y libgconf2-4 libxss1 xdg-utils   #google chrome dependencies
cd ~
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#you have to run: chromedriver  before google-chrome installation
dpkg -i google-chrome-stable_current_amd64.deb


####Artifactory Part ####




























