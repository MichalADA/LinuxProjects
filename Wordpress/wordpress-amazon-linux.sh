#!/bin/bash

sudo yum update -y

# Instalacja Apache (httpd), MariaDB oraz PHP
sudo yum install -y httpd mariadb-server php php-mysqlnd php-fpm php-json

# Start i włączenie Apache oraz MariaDB
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Konfiguracja bazy danych dla WordPressa
sudo mysql -e "CREATE DATABASE wordpress_db;"
sudo mysql -e "CREATE USER 'wordpress_user'@'localhost' IDENTIFIED BY 'bardzo_tajne_haslo';"
sudo mysql -e "GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wordpress_user'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Pobieranie i instalacja WordPressa
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
sudo cp -r wordpress/* /var/www/html/

# Nadanie uprawnień
sudo chown -R apache:apache /var/www/html/
sudo chmod -R 755 /var/www/html/

# Konfiguracja WordPressa
cd /var/www/html
sudo cp wp-config-sample.php wp-config.php
sudo sed -i 's/database_name_here/wordpress_db/' wp-config.php
sudo sed -i 's/username_here/wordpress_user/' wp-config.php
sudo sed -i 's/password_here/bardzo_tajne_haslo/' wp-config.php

# Konfiguracja Apache do obsługi domeny
echo "<VirtualHost *:80>
    ServerName twoja_domena.com
    DocumentRoot /var/www/html

    <Directory /var/www/html>
        AllowOverride All
    </Directory>
</VirtualHost>" | sudo tee /etc/httpd/conf.d/twoja_domena.conf

sudo systemctl restart httpd

