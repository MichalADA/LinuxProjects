#!/bin/bash

# Aktualizacja systemu i instalacja Squid
echo "Aktualizacja systemu..."
sudo apt-get update

echo "Instalacja Squid..."
sudo apt-get install -y squid

# Konfiguracja Squid
SQUID_CONF="/etc/squid/squid.conf"

echo "Konfiguracja Squid..."
sudo cp $SQUID_CONF $SQUID_CONF.bak # Tworzenie kopii zapasowej oryginalnego pliku konfiguracyjnego

# Ustawienie portu HTTP i dodanie ACL
sudo sed -i 's/^http_port.*/http_port 3128/' $SQUID_CONF

sudo bash -c "echo 'acl localnet src 192.168.1.0/24' >> $SQUID_CONF"
sudo bash -c "echo 'http_access allow localnet' >> $SQUID_CONF"

# Restart Squid
echo "Restartowanie Squid..."
sudo systemctl restart squid

echo "Konfiguracja Squid zakończona. Serwer proxy działa na porcie 3128."
