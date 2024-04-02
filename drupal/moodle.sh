#/bin/bash

# Update system 
sudo apt-get update -y && sudo apt-get upgrade -y

# Install Apache Web Server
sudo apt install apache2 -y
sudo systemctl enable apache2 && sudo systemctl start apache2

# Install PHP 8.1 and PHP-FPM
sudo apt-get install php8.1-fpm php8.1-cli php8.1-common php8.1-imap php8.1-redis php8.1-snmp php8.1-xml php8.1-zip php8.1-mbstring php8.1-curl -y

# Enable PHP-FPM
sudo a2enconf php8.1-fpm
sudo systemctl restart apache2

# Install MariaDB
sudo apt install mariadb-server -y
sudo systemctl start mariadb && sudo systemctl enable mariadb

# Secure MariaDB installation (Recommended)
sudo mysql_secure_installation

# MariaDB commands must be run in the MySQL shell or through a script.
# These lines are placeholders for you to execute the equivalent commands within the MySQL shell.
# sudo mysql -u root -p
# CREATE USER 'drupal'@'localhost' IDENTIFIED BY 'nimda1234@';
# CREATE DATABASE drupal;
# GRANT ALL PRIVILEGES ON drupal.* TO 'drupal'@'localhost';
# FLUSH PRIVILEGES;
# EXIT;

# Install Drupal
cd /var/www/html
sudo wget https://ftp.drupal.org/files/projects/drupal-9.3.16.zip
sudo unzip drupal-9.3.16.zip
sudo mv drupal-9.3.16/ drupal/
sudo chown -R www-data:www-data drupal/
sudo find drupal/ -type d -exec chmod 755 {} \;
sudo find drupal/ -type f -exec chmod 644 {} \;

# Create Apache Drupal Config
cat <<EOF | sudo tee /etc/apache2/sites-available/drupal.conf
<VirtualHost *:80>
    ServerName yourdomain.com
    DocumentRoot /var/www/html/drupal

    <FilesMatch \.php$>
        SetHandler "proxy:unix:/var/run/php/php8.1-fpm.sock|fcgi://localhost"
    </FilesMatch>

    <Directory /var/www/html/drupal>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# Enable the Drupal site and Apache modules
sudo a2enmod rewrite proxy proxy_fcgi
sudo a2ensite drupal.conf
sudo apachectl -t
sudo systemctl reload apache2

# Reselove problems 
sudo a2enmod proxy_fcgi
sudo a2enmod proxy
sudo a2enmod rewrite
sudo systemctl restart apache2


#Resolved  Requirements problem

# Install the GD extension
sudo apt-get install php8.1-gd -y

# Install PDO and the MySQL driver for PDO
sudo apt-get install php8.1-pdo php8.1-mysql -y 

# Restart PHP-FPM to apply the changes
sudo systemctl restart php8.1-fpm 

# Restart Apache to apply the changes
sudo systemctl restart apache2 