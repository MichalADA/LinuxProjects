#!/bin/bash

# Aktualizacja repozytorium i instalacja podstawowych narzędzi
apt update -y
apt install curl git nginx -y

# Dodanie użytkownika 'master' i dodanie go do grupy 'sudo'
adduser master --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "master:password" | chpasswd
usermod -aG sudo master

# Instalacja Node.js (LTS version)
curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
apt install nodejs -y

# Zapisanie wersji Node.js i npm do pliku logowego
node -v > log.txt
npm -v >> log.txt

# Pobranie i instalacja Uptime Kuma
git clone https://github.com/louislam/uptime-kuma.git
cd uptime-kuma
npm run setup

# Instalacja PM2 globalnie i uruchomienie Uptime Kuma
sudo npm install pm2 -g
pm2 start server/server.js --name kuma

# Konfiguracja serwera Nginx
cp nginx.conf /etc/nginx/sites-available/kuma.yourdomain.com.conf

# Usuwanie domyślnej strony i włączenie konfiguracji
rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/kuma.yourdomain.com.conf /etc/nginx/sites-enabled/kuma.yourdomain.com.conf

# Restart usługi Nginx, aby zastosować nową konfigurację
systemctl restart nginx
systemctl status nginx

echo "Instalacja Uptime Kuma zakończona!"
