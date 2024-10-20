#!/bin/bash

# Zaktualizuj pakiety
sudo apt-get update

# Zainstaluj wymagane pakiety
sudo apt-get install -y wget apt-transport-https

# Pobierz i dodaj klucz GPG repozytorium Elastic
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

# Dodaj repozytorium Elastic do listy źródeł APT
sudo sh -c 'echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" > /etc/apt/sources.list.d/elastic-7.x.list'

# Zaktualizuj listę pakietów
sudo apt-get update

# Zainstaluj Filebeat
sudo apt-get install -y filebeat

# Skonfiguruj Filebeat, aby wysyłał logi do Elasticsearch
sudo tee /etc/filebeat/filebeat.yml > /dev/null <<EOL
filebeat.inputs:
  - type: log
    enabled: true
    paths:
      - /var/log/*.log

output.elasticsearch:
  hosts: ["http://3.87.64.167:9200"]
  protocol: "http"

setup.kibana:
  host: "http://3.87.64.167:5601"

processors:
  - add_host_metadata:
      when.not.contains.tags: forwarded
  - add_cloud_metadata: ~
  - add_docker_metadata: ~
  - add_kubernetes_metadata: ~
EOL

# Włącz Filebeat jako usługę systemową
sudo systemctl enable filebeat

# Uruchom usługę Filebeat
sudo systemctl start filebeat

# Ustawienie Filebeat w celu automatycznego skonfigurowania dashboardów w Kibana
sudo filebeat setup --dashboards
