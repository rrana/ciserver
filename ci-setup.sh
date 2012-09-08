#!/bin/bash
set -e -x

#rana.ete.nsu@gmail.com

#RUN THIS SCRIPT AS ROOT USER

#export DEBIAN_FRONTEND=noninteractive

# Packages
apt-get update && sudo apt-get upgrade -y
apt-get install build-essential -y

####Jenkins Part ####

##Java installation

echo deb http://ftp.fr.debian.org/debian/ squeeze non-free >> /etc/apt/sources.list
echo deb-src http://ftp.fr.debian.org/debian/ squeeze non-free >> /etc/apt/sources.list
apt-get update
apt-get install sun-java6-bin -y
apt-get install sun-java6-jdk -y

##Jenkins Installation
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
echo deb http://pkg.jenkins-ci.org/debian binary/ >> /etc/apt/source.list
apt-get update
apt-get install jenkins -y

##Apache installation
aptitude install libpcre3-dev libpcrecpp0 libssl-dev zlib1g-dev libgeoip-dev -y
apt-get install apache2 -y

a2enmod proxy
a2enmod proxy_http
a2enmod vhost_alias
a2dissite default
#Creating apache vhost file for jenkins
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

#enabling jenkins vhost
a2ensite jenkins

#restarting apache
/etc/init.d/apache2 stop
/etc/init.d/apache2 start

#Jenkins login URL: ci.test.com (as mentioned in apache vhost file. You have to change this according to your domain information) OR http://localhost/

##ANT Installation
apt-get install ant

##Installation of Selenium

#XVFB Installation
apt-get install xvfb

#Unzip
apt-get install unzip

#chrome driver installation
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
#You can test chrome driver by running: chromedriver in your terminal

apt-get install lo-menubar
#apt-get install ImageMagick
apt-get install graphviz

#google chrome dependencies
apt-get install -y libgconf2-4 libxss1 xdg-utils   
cd ~
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#you have to run: chromedriver  before google-chrome installation
#Run the following two command manually at the end of this script installation
#chromedriver
#dpkg -i google-chrome-stable_current_amd64.deb


####Artifactory Part ####

#Setting environment
echo JAVA_HOME=/usr/lib/jvm/java-6-sun/ >> /etc/environment
echo export JAVA_HOME=/usr/lib/jvm/java-6-sun/ >> /etc/profile
echo export JAVA_HOME=/usr/lib/jvm/java-6-sun/ >> ~/.bash_profile
source ~/.bash_profile

#For test purpose I am downloading an evaluation version of Artifactory. You have to change this download link after wget with your licensed version's #download link:
cd ~
wget https://store.artifactoryonline.com/addons/download?license=32b67fea0faca0b9227d0e61623ac8cdbbcc4711
mv download\?license\=32b67fea0faca0b9227d0e61623ac8cdbbcc4711 artifactory-powerpack-standalone-2.6.3.zip
unzip artifactory-powerpack-standalone-2.6.3.zip
cd artifactory-powerpack-2.6.3/bin/
./install.sh

echo export JAVA_HOME=/usr/lib/jvm/java-6-sun/jre >> /etc/artifactory/default

## You can check artifactory installation with: service artifactory check
## active artifactory with: service artifactory start

service artifactory start

#After successful run your Artifactory login url will be: http://ec2-75-101-213-8.compute-1.amazonaws.com:8081/artifactory/
#Default Artifactory login information: user/pass is admin/password