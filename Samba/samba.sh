#!/bin/bash

# Aktualizacja systemu i instalacja Samby
echo "Aktualizacja systemu..."
sudo apt-get update

echo "Instalacja Samby..."
sudo apt-get install -y samba

# Utworzenie katalogu do udostępnienia
SHARED_DIR="/srv/samba/shared"
echo "Tworzenie katalogu do udostępnienia: $SHARED_DIR"
sudo mkdir -p $SHARED_DIR

# Nadanie odpowiednich uprawnień
echo "Nadanie uprawnień do katalogu: $SHARED_DIR"
sudo chown -R nobody:nogroup $SHARED_DIR
sudo chmod -R 0775 $SHARED_DIR

# Dodanie użytkownika Samba
SAMBA_USER="sambashare"
echo "Dodawanie użytkownika Samba: $SAMBA_USER"
sudo adduser --no-create-home --disabled-password --gecos "" $SAMBA_USER
echo "Ustawianie hasła dla użytkownika Samba: $SAMBA_USER"
(echo "samba_password"; echo "samba_password") | sudo smbpasswd -a $SAMBA_USER

# Konfiguracja Samby
SAMBA_CONF="/etc/samba/smb.conf"
echo "Konfiguracja Samby: $SAMBA_CONF"
sudo cp $SAMBA_CONF $SAMBA_CONF.bak # Tworzenie kopii zapasowej oryginalnego pliku konfiguracyjnego

# Dodanie konfiguracji do pliku smb.conf
sudo bash -c "cat >> $SAMBA_CONF <<EOL

[shared]
   path = $SHARED_DIR
   available = yes
   valid users = @$SAMBA_USER
   read only = no
   browsable = yes
   public = yes
   writable = yes
EOL"

# Restart Samby
echo "Restartowanie Samby..."
sudo systemctl restart smbd

echo "Konfiguracja Samby zakończona. Serwer NAS działa."
