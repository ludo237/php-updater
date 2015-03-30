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

# Defining useful variables
mout=make_output.txt
miout=make_install_output.txt
directory=/tmp/php-updater

# Check if the current extension is active
is_active(){
  exists=`php -m | grep $1`;
  if [ -z "$exists" ]; then
      echo "$exists not installed";
  else
      echo "$exists installed!!";
  fi
}

# Install a PHP extension
install_extension(){
    cd ext/$1
    phpize > /dev/null
    ./configure -q > /dev/null
    make &> $mout
    sudo make install &> $miout
}

echo "---------";
echo "--------- Checking dependencies";
echo "--------- Please provide root password when prompted";
sudo apt-get -qq update && sudo apt-get install -y make wget git libxml2 libxml2-dev
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
./configure -q --with-config-file-path=/usr/local/lib/ --enable-fpm --enable-phpdbg  --enable-phpdbg-debug --with-system-ciphers --enable-bcmath --enable-dba --enable-exif --enable-mbstring --with-mysql --enable-opcache
echo "---------";
echo "--------- Making PHP with make, this process could take some minutes. Please wait...";
make -s clean
make &> $mout
echo "---------";
echo "--------- Installing PHP v5.6.7, it will require super user password. Pleae provide it when prompted";
sudo make install &> $miout
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
install_extension mcrypt;
echo "---------";
echo "--------- Checking if mycrypt is installed";
is_active mcrypt;
echo "---------";
echo "--------- Installing gd";
install_extension gd;
echo "---------";
echo "--------- Checking if GD is installed";
is_active gd;
echo "-----------------------------------------------------------------";
echo "---------                                                 -------";
echo "---------                 Update complete                 -------";
echo "---------              Have fun with PHP v5.6.7           -------";
echo "---------                                                 -------";
echo "-----------------------------------------------------------------";
