#!/bin/bash

# Zmienne - dostosuj do swoich potrzeb
MOODLE_DB="moodle_db"
MOODLE_DB_USER="moodle_user"
MOODLE_DB_PASS="twoje_haslo"
SERVER_NAME="twojadomena.pl"

# Zaktualizuj system
sudo apt update && sudo apt upgrade -y

# Instaluj Apache2, MySQL i PHP wraz z wymaganymi rozszerzeniami
sudo apt install apache2 mysql-server php libapache2-mod-php php-mysql php-xml php-cli php-json php-zip php-gd php-mbstring php-curl php-xmlrpc git -y

# Konfiguracja MySQL
sudo mysql -e "CREATE DATABASE ${MOODLE_DB} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
sudo mysql -e "CREATE USER '${MOODLE_DB_USER}'@'localhost' IDENTIFIED BY '${MOODLE_DB_PASS}';"
sudo mysql -e "GRANT ALL PRIVILEGES ON ${MOODLE_DB}.* TO '${MOODLE_DB_USER}'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Pobieranie Moodle z git
cd /opt
sudo git clone git://git.moodle.org/moodle.git
cd moodle
sudo git branch -a
sudo git branch --track MOODLE_400_STABLE origin/MOODLE_400_STABLE
sudo git checkout MOODLE_400_STABLE

# Kopiowanie Moodle do katalogu serwera WWW
sudo cp -R /opt/moodle /var/www/html/

# Ustawienie katalogu danych Moodle
sudo mkdir /var/moodledata
sudo chown -R www-data /var/moodledata
sudo chmod -R 777 /var/moodledata 

# Nadanie odpowiednich uprawnień dla katalogu Moodle
sudo chmod -R 0755 /var/www/html/moodle

# Konfiguracja Apache2
sudo bash -c "cat > /etc/apache2/sites-available/moodle.conf <<EOF
<VirtualHost *:80>
     ServerAdmin admin@${SERVER_NAME}
     DocumentRoot /var/www/html/moodle
     ServerName ${SERVER_NAME}

     <Directory /var/www/html/moodle/>
          Options FollowSymlinks
          AllowOverride All
          Require all granted
     </Directory>

     ErrorLog \${APACHE_LOG_DIR}/error.log
     CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF"

# Włączenie nowej konfiguracji i przeprowadzenie restartu Apache
sudo a2ensite moodle.conf
sudo a2enmod rewrite
sudo systemctl restart apache2

# Opcjonalnie: Konfiguracja SSL z Let's Encrypt
# sudo apt install certbot python3-certbot-apache -y
# sudo certbot --apache -d ${SERVER_NAME}

echo "Instalacja Moodle zakończona. Przejdź do http://${SERVER_NAME} aby dokończyć instalację przez przeglądarkę."
