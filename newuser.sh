#!/bin/bash
if [ "$(id -u)" = "0" ]; then #Check if the user is root or not
var=$((501 + RANDOM % 1000001)) #random generator between 501 and 1000001
echo "This is user script made by user group 10."
username="newbee"
password="newbee"
#read -p "Enter username : " username
#read -s -p "Enter password : " password
echo "$username:x:$var:0:10:180:14:0:" >> /etc/shadow #store userdata and password expiration
echo "$username:x:$var:$var::/home/$username:/bin/bash" >>
/etc/passwd #write the username and profile number
echo "$username:$password" | chpasswd -c SHA512 #change password and encrypt with sha512 algorithm
echo "$username:x:$var" >> /etc/group #store group id number
cd /home #go to home directory
mkdir $username #create a folder dedicated to the user inside home directory
chmod 700 /home/$username # set owner permission to rwx whereas group and public to be no access
chown -R $username /home/$username #change the ownership to newly created user
echo "The user has been successuflly created"
else
echo "THIS SCRIPT CAN ONLY BE USED BY THE ROOT USER."
fi