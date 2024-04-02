#!/bin/bash

# Definiowanie adresu URL GitLab
GITLAB_EXTERNAL_URL="http://gitlab.twojadomena.com" #  url do zmiany 

# Aktualizacja systemu
sudo apt-get update -y
sudo apt-get upgrade -y

# Instalacja zależności
sudo apt-get install -y curl openssh-server ca-certificates

# Instalacja Postfix do wysyłania e-maili
sudo apt-get install -y postfix

# Pobieranie i instalacja skryptu GitLab
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash

# Instalacja GitLab CE
sudo EXTERNAL_URL="$GITLAB_EXTERNAL_URL" apt-get install gitlab-ce -y

# Konfiguracja GitLab
sudo gitlab-ctl reconfigure

echo "Instalacja GitLab zakończona. Otwórz $GITLAB_EXTERNAL_URL w przeglądarce, aby kontynuować konfigurację."
sudo EXTERNAL_URL="gitlab.hinas.xyz" apt install gitlab-ce
