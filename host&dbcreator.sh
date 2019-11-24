#!/bin/bash

if [ "$(whoami)" != 'root' ]; then
        echo "You have no permission to run $0 as non-root user. Use sudo or switch to root user!!!"
        exit 1;
fi
##############################################################################
#
#                 This creates a domain
#
##############################################################################

ROOT="/var/www/html/"

if [ ! -d "$ROOT" ]; then
  mkdir -p $ROOT
fi

#
echo " Enter the domain name: "
read DOMAIN
#


if [  -d "$ROOT/$DOMAIN" ]; then
  echo $DOMAIN already exist
  exit 1
fi

DOCROOT="$ROOT/$DOMAIN/"
mkdir -p $DOCROOT

if [ ! -d "$ROOT" ]; then
  mkdir -p $ROOT
fi

echo "<VirtualHost *:80>
     ServerName $DOMAIN
     ServerAlias www.$DOMAIN
     DocumentRoot $DOCROOT
     ErrorLog /var/log/httpd/$DOMAIN-error.log
     CustomLog /var/log/httpd/$DOMAIN-access.log common
       <Directory $DOCROOT>
          AllowOverride All
       </Directory>
</VirtualHost>" " |  tee --append /etc/httpd/vhost.d/$DOMAIN.conf"

##############################################################################
#
#                 This creates a database and  user 
#
##############################################################################

# create random password
PASSWDDB="$(openssl rand -base64 12)"

# replace "-" with "_" for database username
hostname=myserver.site.mydomain.com
output=${DOMAIN%%.*}
MAINDB=${output}

# If /root/.my.cnf exists then it won't ask for root password
if [ -f /root/.my.cnf ]; then

    mysql -e "CREATE DATABASE ${MAINDB};"
    mysql -e "CREATE USER ${MAINDB}@localhost IDENTIFIED BY '${PASSWDDB}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${MAINDB}.* TO '${MAINDB}'@'localhost';"
    mysql -e "FLUSH PRIVILEGES;"

# If /root/.my.cnf doesn't exist then it'll ask for root password   
else
    echo "Please enter root user MySQL password!"
    read rootpasswd
    mysql -uroot -p${rootpasswd} -e "CREATE DATABASE ${MAINDB};"
    mysql -uroot -p${rootpasswd} -e "CREATE USER ${MAINDB}@localhost IDENTIFIED BY '${PASSWDDB}';"
    mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON ${MAINDB}.* TO '${MAINDB}'@'localhost';"
    mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
fi


if [ $? != "0" ]; then
 echo "[Error]: Database creation failed"
 exit 1
else

 echo "------------------------------------------"
 echo " Database has been created successfully "
 echo "------------------------------------------"
 echo " DB Info: "
 echo ""
 echo " DB Name: $MAINDB" 
 echo " DB User: $MAINDB" 
 echo " DB Pass: $PASSWDDB" 
 echo ""
 echo "------------------------------------------"

 echo "------------------------------------------"
 echo " Database has been created stored on root "
 echo "------------------------------------------"

 echo " DB Info: "   >> database.txt
 echo " DB Name: $MAINDB" >> database.txt
 echo " DB User: $MAINDB" >> database.txt
 echo " DB Pass: $PASSWDDB" >> database.txt
 echo "------------------------------------------"  >> database.txt

 fi

##############################################################################
#
#              This installs VISICHAT
#
##############################################################################
## Unzip and create folders
function VISICHAT(){
cd $DOCROOT

wget https://archive.org/download/Visichat3.1.0/Visichat-3.1.0.zip
unzip Visichat-3.1.0.zip
rm -rf  Visichat-3.1.0.zip
chown -R apache:apache config.php files/avatars files/banners files/cache files/games files/members files/mp3 files/music files/skins files/thumbnails files/widgets

echo  "DATABASE NAME: $MAINDB   USERNAME: $MAINDB   PASSWORD: $PASSWDDB" > /var/www/html/$DOMAIN/databaseinfo.txt
}
echo " "
echo " "
VISICHAT
echo "Please wait ... "

echo "##############################################################################
#
#              Your domain have been added and the database is created!
#
##############################################################################
"


###Created by Sache (c)