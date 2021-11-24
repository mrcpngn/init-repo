#!/bin/bash
sudo localectl set-locale LANG=ja_JP.UTF-8
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo yum install -y php7.2 php php-mysql php-fpm
sudo touch /var/www/html/info.php
sudo echo "<?php phpinfo(); ?>" > /var/www/html/info.php
sudo systemctl restart httpd