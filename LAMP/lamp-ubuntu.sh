#!/bin/bash

# Aktualizacja systemu
sudo apt update && sudo apt upgrade -y

# Instalacja Apache2
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2

# Instalacja MySQL
sudo apt install mysql-server -y
echo "Uruchom 'sudo mysql_secure_installation' aby zabezpieczyć MySQL."

# Instalacja PHP
sudo apt install php libapache2-mod-php php-mysql -y

# Modyfikacja Apache, aby preferował PHP
sudo sed -i 's/index.html index.cgi index.pl index.php index.xhtml index.htm/index.php index.html index.cgi index.pl index.xhtml index.htm/' /etc/apache2/mods-enabled/dir.conf

# Restart Apache, aby zastosować zmiany
sudo systemctl restart apache2

echo "Instalacja LAMP zakończona."
