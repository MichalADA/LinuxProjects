#!/bin/bash

# Aktualizacja systemu
sudo yum update -y

# Instalacja Apache
sudo yum install httpd -y
sudo systemctl enable httpd
sudo systemctl start httpd

# Instalacja PostgreSQL
sudo yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm -y
sudo yum install postgresql12-server postgresql12 -y
sudo /usr/pgsql-12/bin/postgresql-12-setup initdb
sudo systemctl enable postgresql-12
sudo systemctl start postgresql-12

# Konfiguracja bazy danych i użytkownika PostgreSQL
sudo -u postgres psql -c "CREATE DATABASE testbaza;"
sudo -u postgres psql -c "CREATE USER myuser WITH ENCRYPTED PASSWORD 'asddasdsdass';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE mydatabase TO darin;"

# Instalacja PHP i potrzebnych modułów
sudo yum install php php-pgsql -y
sudo systemctl restart httpd

echo "Instalacja LAPP zakończona. Baza danych i użytkownik PosstgreSQL zostali skonfigurowani."

