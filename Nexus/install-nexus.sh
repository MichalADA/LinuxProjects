#!/bin/bash

# Update system and install Java 17
sudo apt update && sudo apt upgrade -y
sudo apt install openjdk-17-jdk -y

# Check Java version
java -version

# Create directories and user for Nexus
sudo mkdir /opt/nexus
sudo useradd -d /opt/nexus -s /bin/bash nexus
sudo passwd nexus  # Optionally, you can set a password for the 'nexus' user
ulimit -n 65536  # Set the maximum number of open files

# Configure open file limits for Nexus user
echo "nexus - nofile 65536" | sudo tee /etc/security/limits.d/nexus.conf

# Download and unpack Nexus
cd /tmp/
sudo wget https://download.sonatype.com/nexus/3/nexus-3.73.0-12-unix.tar.gz
sudo tar xzf nexus-3.73.0-12-unix.tar.gz

# Move Nexus files to /opt/nexus
sudo mv nexus-3.73.0-12/* /opt/nexus
sudo mv sonatype-work /opt/sonatype-work

# Set permissions for Nexus user
sudo chown -R nexus:nexus /opt/nexus /opt/sonatype-work

# Configure nexus.rc file
echo 'run_as_user="nexus"' | sudo tee /opt/nexus/bin/nexus.rc

# Open port 8081 in the firewall (if using UFW)
sudo ufw allow 8081/tcp

# Create Nexus systemd service
sudo bash -c 'cat <<EOT > /etc/systemd/system/nexus.service
[Unit]
Description=Nexus Repository Manager
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/bin/bash /opt/nexus/bin/nexus start
ExecStop=/bin/bash /opt/nexus/bin/nexus stop
Environment="JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64"
Environment="NEXUS_HOME=/opt/nexus"
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOT'

# Reload systemd and start Nexus service
sudo systemctl daemon-reload
sudo systemctl start nexus
sudo systemctl status nexus

# Enable Nexus service to start on boot
sudo systemctl enable nexus

echo "Nexus installation and setup complete."