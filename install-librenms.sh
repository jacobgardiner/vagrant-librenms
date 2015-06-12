#!/bin/bash

# This is the script to run inside the VM to install librenms

# setup epel, fastest mirror because SL mirrors are slow.
rpm -ivh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
yum install -y --disablerepo="*" --enablerepo="sl" yum-plugin-fastestmirror
sed -i 's/^#mirrorlist/mirrorlist/' /etc/yum.repos.d/*.repo
yum clean all

# Install deps
yum install -y git net-snmp mysql-server php php-cli php-gd php-mysql php-snmp php-pear php-curl nginx php-fpm net-snmp graphviz graphviz-php mysql ImageMagick jwhois nmap mtr rrdtool MySQL-python net-snmp-utils vixie-cron php-mcrypt fping git
pear install Net_IPv4-1.3.4
pear install Net_IPv6-1.2.2b2

# Start mysql, snmpd
service snmpd start
service mysqld start
chkconfig --levels 235 mysqld on
chkconfig --levels 235 snmpd on


# Setup DB
create_user="CREATE USER 'librenms'@'localhost' IDENTIFIED by 'librenms';"

create_db="CREATE DATABASE librenms;
GRANT ALL PRIVILEGES ON librenms.*
  TO 'librenms'@'localhost'
;
FLUSH PRIVILEGES;
exit"

mysql -uroot -e "$create_user"
mysql -uroot -e "$create_db"

# Clone librenms
cd /opt
git clone https://github.com/librenms/librenms.git librenms
cd /opt/librenms

# Setup librenms
ln -sf /vagrant/setup/config.php config.php
php build-base.php
php adduser.php admin admin 10

mkdir rrd logs
chown nginx:nginx logs

chmod 775 rrd
chown librenms:librenms rrd

# setup cron
cat > /etc/cron.d/librenms << EOF
*/5 * * * * librenms /opt/librenms/poller-wrapper.py 12 >> /dev/null 2>&1
EOF


# Setup user, add to nginx group
useradd librenms -d /opt/librenms -M -r
usermod -a -G librenms nginx

# Setup nginx & php-fpm
ln -sf /vagrant/setup/librenms-nginx.conf /etc/nginx/conf.d/librenms.conf

sed -i 's/^listen = 127.0.0.1:9000/listen = \/var\/run\/php5-fpm.sock/' /etc/php-fpm.d/www.conf
sed -i 's/^user = apache/user = nginx/' /etc/php-fpm.d/www.conf
sed -i 's/^group = apache/group = nginx/' /etc/php-fpm.d/www.conf

chkconfig --levels 235 nginx on
chkconfig --levels 235 php-fpm on
service nginx start
service php-fpm start
chown root:nginx /var/lib/php -R

# remove iptables rules
iptables -F
rm /etc/sysconfig/iptables
