#!/bin/bash

# Zaktualizuj pakiety
sudo apt-get update

# Zainstaluj wymagane pakiety
sudo apt-get install -y ca-certificates curl

# Utwórz katalog na klucze apt
sudo install -m 0755 -d /etc/apt/keyrings

# Pobierz klucz GPG Dockera
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

# Ustaw odpowiednie uprawnienia dla klucza
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Dodaj repozytorium Dockera do apt
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Zaktualizuj listę pakietów
sudo apt-get update

# Zainstaluj Docker, Docker CLI, Containerd i Docker Compose Plugin
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Uruchom usługę Docker
sudo service docker start

# Włącz Dockera, aby uruchamiał się automatycznie po restarcie
sudo systemctl enable docker

# Dodaj użytkownika do grupy docker (domyślnie "ubuntu" lub "ec2-user")
sudo usermod -aG docker $USER

# Informacja o pomyślnej instalacji
echo "Docker i Docker Compose zostały zainstalowane pomyślnie!"
