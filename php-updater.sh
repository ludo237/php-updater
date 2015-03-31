#!/bin/bash

##############################################################
#                                                           ##
# Creator: Claudio Ludovico Panetta (@ludo237)              ##
# License: MIT                                              ##
# Official Support: https://github.com/ludo237/PHP-updater/ ##
#                                                           ##
##############################################################

# Check if this script is forced by sudo
if [ `id -u` -eq 0 ]; then
    echo "Please Do Not Run this script as sudo";
    exit;
fi;

# Defining useful variables
current_version=php-5.6.7
mout=make_output.txt
miout=make_install_output.txt
directory=/tmp/php-updater
inidir=/usr/local/lib/php.ini

# Check if the current extension is active
is_active(){
    exists=`php -m | grep $1`;
    if [ -z "$exists" ]; then
        echo "Error while installing $1, switching to the manual approach";
        echo "extension=$1.so" >> $inidir
        is_active $1;
    else
        echo "$exists installed!!";
        return;
    fi;
}
# Install a PHP extension
install_extension(){
    echo "--------- Installing $1";
    cd $directory/$current_version/ext/$1
    phpize > /dev/null
    ./configure -q > /dev/null
    make &> $mout
    sudo make install &> $miout
    is_active $1;
}

clear 

echo "-----------------------------------------------------------------";
echo "---------                                                 -------";
echo "---------           Welcome to PHP Updater v0.0.1         -------";
echo "---------                                                 -------";
echo "--------- Interactive script to update PHP                -------";
echo "--------- please note, this update will install           -------";
echo "--------- $current_version with default configurations    -------";
echo "--------- If you need something more specific please      -------";
echo "--------- create an issue on the repository on Github.com -------";
echo "---------                                                 -------";
echo "-----------------------------------------------------------------";

echo "---------";
echo "--------- Checking dependencies";
echo "--------- Please provide root password when prompted";
sudo apt-get -qq update && sudo apt-get install -y autoconf curl git libcurl4-gnutls-dev libmcrypt-dev libxml2 libxml2-dev make mcrypt re2c wget
echo "---------";
echo "--------- Creating a folder inside /tmp in order to keep your directory clean";
if [ -d $directory  ]; then
    rm -r $directory
fi;

mkdir -p $directory
echo "---------";
echo "--------- Current Directory changed to $directory";
cd $directory
echo "---------";
echo "--------- Fetching $current_version from a mirror, please wait...";
wget -q http://bg2.php.net/get/$current_version.tar.gz/from/this/mirror
echo "---------"; 
echo "--------- Extracting PHP Source code";
tar zxf mirror && rm mirror
echo "---------";
echo "--------- Current Directory changed to $directory/$current_version";
cd $current_version
echo "---------";
echo "--------- Configuring PHP with default configurations, please wait";
echo "--------- Do not type anything";
./configure -q --with-config-file-path=/usr/local/lib/ --enable-fpm --enable-phpdbg --enable-phpdbg-debug --with-system-ciphers --enable-bcmath --enable-dba --enable-exif --enable-mbstring --with-mysql --enable-opcache --with-curl
echo "---------";
echo "--------- Making PHP with make, this process could take some minutes. Please wait...";
make -s clean
make &> $mout
echo "---------";
echo "--------- Installing $current_version, it will require super user password. Pleae provide it when prompted";
sudo make install &> $miout
echo "---------";
echo "--------- Checking your PHP version";
php -v
echo "---------";
echo "--------- Generating PHP.ini default file in /usr/local/lib called php.ini";
sudo cp php.ini-production $inidir
sudo chown `whoami`:`whoami` $inidir
echo "---------";
echo "--------- php.ini is in Production mode";
echo "--------- Current php ini configurations";
php --ini
echo "---------";
echo "--------- Installing common and useful extensions. Provide password when prompted";
install_extension mcrypt;
echo "---------";
install_extension mysql;
echo "---------";
install_extension mysqli;
echo "---------";
install_extension json;
echo "---------";
install_extension curl;
echo "---------";
install_extension pdo;
echo "-----------------------------------------------------------------";
echo "---------                                                 -------";
echo "---------                 Update complete                 -------";
echo "---------              Have fun with $current_version     -------";
echo "---------                                                 -------";
echo "-----------------------------------------------------------------";
