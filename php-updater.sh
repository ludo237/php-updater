#!/bin/bash

echo "-----------------------------------------------------------------";
echo "---------                                                 -------";
echo "---------           Welcome to PHP Updater v0.0.1         -------";
echo "---------                                                 -------";
echo "--------- Interactive script to update PHP                -------";
echo "--------- please note, this update will install           -------";
echo "--------- PHP v5.6.7 with default configurations          -------";
echo "--------- If you need something more specific please      -------";
echo "--------- create an issue on the repository on Github.com -------";
echo "---------                                                 -------";
echo "-----------------------------------------------------------------";

echo "--------- This script require Super User permissions, please provide sudo password";
directory=/tmp/php-updater
echo "---------";
echo "--------- Checking dependencies";
echo "--------- Please provide root password when prompeted";
sudo apt-get -qq update && sudo apt-get install -y make wget git
echo "---------";
echo "--------- Creating a folder inside /tmp in order to keep your directory clean";
if [ -d $directory  ]; then
    rm -r $directory
fi;

mkdir -p $directory
echo "---------";
echo "--------- Current Directory changed to /tmp/php-updater";
cd $directory
echo "---------";
echo "--------- Fetching PHP v5.6.7 from a mirror, please wait...";
wget -q http://it1.php.net/get/php-5.6.7.tar.gz/from/this/mirror
echo "---------"; 
echo "--------- Extracting PHP Source code";
tar zxf mirror && rm mirror
echo "---------";
echo "--------- Current Directory changed to /tmp/php-updater/php-5.6.7";
cd php-5.6.7
echo "---------";
echo "--------- Configuring PHP with default configurations, please wait";
echo "--------- Do not type anything";
./configure -q --with-config-file-path=/usr/local/lib/ --enable-fpm --enable-phpdbg  --enable-phpdbg-debug --enable-debug --with-system-ciphers --enable-bcmath --enable-dba --enable-exif --enable-mbstring --with-mysql --enable-opcache
echo "---------";
echo "--------- Making PHP with make";
make -s clean
make -s 
echo "---------";
echo "--------- Testing with make test";
make -s test
echo "---------";
echo "--------- Installing PHP v5.6.7, it will require super user password. Pleae provide it when prompted";
sudo make -s install
echo "---------";
echo "--------- Checking your PHP version";
php -v
echo "---------";
echo "--------- Generating PHP.ini default file in /usr/local/lib called php.ini";
sudo cp php.ini-production /usr/local/lib/php.ini
echo "---------";
echo "--------- php.ini is in Production mode";
echo "--------- Current php ini configurations";
php --ini
echo "---------";
echo "--------- Installing common and useful extensionsi. Provide password when prompted";
echo "--------- Installing mcrypt";
cd /ext/mcrypt && phpize && aclocal && make -s && sudo make -s install
echo "---------";
echo "--------- Installing gd";
cd /ext/gd && phpize && aclocal && make -s && sudo make -s install
echo "---------";
echo "--------- Removing Super User timestamp";
sudo -k
echo "-----------------------------------------------------------------";
echo "---------                                                 -------";
echo "---------                 Update complete                 -------";
echo "---------              Have fun with PHP v5.6.7           -------";
echo "---------                                                 -------";
echo "-----------------------------------------------------------------";
