#!/bin/bash

# Script tu dong tai ban WordPress moi nhat va cai dat tao boi Luan Tran - https://hocvps.com/

while [ 1 ]; do
    clear
    printf "=========================================================================\n"
    printf "Chuan bi qua trinh tai ban cai dat WordPress... \n"
    printf "=========================================================================\n"

    printf "Dang sinh thong tin ngau nhien... \n"

    # Generate random MySQL database information
    mysqlhost="localhost"
    mysqldb="wp_$(date +%s)"
    mysqluser="user_$(date +%s)"
    mysqlpass="$(date | md5sum | cut -c1-12)"

    break
done

clear
printf "=========================================================================\n"
printf "Downloading... \n"
printf "=========================================================================\n"

# Download latest WordPress and uncompress
wget http://wordpress.org/latest.tar.gz
tar zxf latest.tar.gz
mv wordpress/* ./

# Grab Salt Keys
wget -O /tmp/wp.keys https://api.wordpress.org/secret-key/1.1/salt/

# Butcher our wp-config.php file
sed -e "s/localhost/$mysqlhost/" -e "s/database_name_here/$mysqldb/" -e "s/username_here/$mysqluser/" -e "s/password_here/$mysqlpass/" wp-config-sample.php > wp-config.php
sed -i '/#@-/r /tmp/wp.keys' wp-config.php
sed -i "/#@+/,/#@-/d" wp-config.php

# Tidy up
rmdir wordpress
rm latest.tar.gz
rm /tmp/wp.keys
rm wp

# Chown
if [ -f /etc/redhat-release ]; then # CentOS
    if ps ax | grep -v grep | grep 'httpd' > /dev/null; then # Apache
        chown -R apache:apache *
    elif ps ax | grep -v grep | grep 'nginx' > /dev/null; then # Nginx
        chown -R nginx:nginx *
    fi
elif [ -f /etc/lsb-release ]; then # Ubuntu
    chown -R www-data:www-data * # Both for Apache and Nginx
fi

clear
printf "=========================================================================\n"
printf "=========================================================================\n"

# Display IP:Port and user:pass information
printf "IP:Port: $(hostname -I):80\n"
printf "User:Pass: admin:$mysqlpass\n"
