#!/bin/bash
yum update -y
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
yum -y --enablerepo=remi,remi-php71 install httpd php php-common
yum --enablerepo=remi,remi-php71 install php-cli php-pear php-pdo php-mysqlnd php-gd php-mbstring php-mcrypt php-xml httpd  mysql wget
yum -y install mariadb-server mariadb
yum install bash-completion -y
systemctl enable httpd.service
systemctl start httpd.service
systemctl enable mariadb
systemctl start mariadb.service
mysql -u root -e "create database wordpressdb";
mysql -u root -e "GRANT ALL PRIVILEGES ON wordpressdb.* TO 'root'@'localhost' IDENTIFIED BY 'cloudthat@123'";
mysql -u root -pcloudthat@123 -e "FLUSH PRIVILEGES;"
mysql -u root -pcloudthat@123 -e "EXIT;"
wget -c http://wordpress.org/latest.tar.gz
wget http://files.cloudthat.com/gcp/wp-config.php
tar -xzvf latest.tar.gz
rsync -av wordpress/* /var/www/html/
mv wp-config.php /var/www/html
sed -i 's/^\(SELINUX\s*=\s*\).*$/\1disabled/' /etc/selinux/config
rm -rf latest.tar.gz wordpress
find /var/www/html -type f -exec chmod 0664 {} \;
find /var/www/html -type d -exec chmod 2775 {} \;
chown -R apache:apache /var/www/html
echo "Rebooting..........!!!!!!!!!!!!!!!!"
reboot
