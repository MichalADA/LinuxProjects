resource "aws_key_pair" "elk_key_pair" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "elk_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
  key_name      = aws_key_pair.elk_key_pair.key_name
  security_groups = [aws_security_group.elk_security_group.name]
  
  user_data = <<-EOF
              #!/bin/bash
              # Update the package list
              sudo apt-get update

              # Install necessary packages
              sudo apt-get install -y ca-certificates curl

              # Set up the Docker repository
              sudo install -m 0755 -d /etc/apt/keyrings
              sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
              sudo chmod a+r /etc/apt/keyrings/docker.asc

              # Add the Docker repository to APT sources
              echo \
                "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
                $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
                sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

              # Update the package list again
              sudo apt-get update

              # Install Docker, Docker CLI, Containerd, and Docker Compose Plugin
              sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

              # Start Docker service
              sudo service docker start

              # Enable Docker to start on boot
              sudo systemctl enable docker

              # Add ubuntu user to the docker group
              sudo usermod -aG docker ubuntu
              EOF 

  tags = {
    Name = "ELK-Server"
  }
}
