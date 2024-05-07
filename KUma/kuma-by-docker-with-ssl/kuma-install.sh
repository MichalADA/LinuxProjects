#!/bin/bash

# Aktualizacja repozytorium i instalacja Docker oraz docker-compose
domain_name="wpisacjakas_dome"

apt update -y
apt install curl git nginx certbot python3-certbot-nginx -y

# Instalacja Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Instalacja Docker Compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Tworzenie katalogu dla Uptime Kuma i plików konfiguracyjnych
mkdir -p /opt/uptime-kuma
cd /opt/uptime-kuma

# Pobieranie pliku docker-compose.yml
curl -o docker-compose.yml https://example.com/path/to/your/docker-compose.yml

# Uruchomienie Uptime Kuma
docker-compose up -d

# Konfiguracja SSL za pomocą Let's Encrypt i Certbot
echo "Wprowadź nazwę domeny dla Uptime Kuma (np. kuma.yourdomain.com):"
read domain_name
certbot --nginx -d $domain_name

# Konfiguracja serwera Nginx z SSL
echo "server {
    listen 443 ssl;
    server_name $domain_name;

    ssl_certificate /etc/letsencrypt/live/$domain_name/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$domain_name/privkey.pem;

    location / {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}" > /etc/nginx/sites-available/kuma.conf

# Usuwanie domyślnej strony i włączenie konfiguracji
rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/kuma.conf /etc/nginx/sites-enabled/kuma.conf

# Restart usługi Nginx, aby zastosować nową konfigurację
systemctl restart nginx

echo "Instalacja Uptime Kuma zakończona! Uptime Kuma jest dostępna przez HTTPS pod adresem https://$domain_name"
