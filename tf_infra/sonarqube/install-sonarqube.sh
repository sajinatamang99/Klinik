#!/bin/bash

# System limits
echo "vm.max_map_count=262144" >> /etc/sysctl.conf
echo "fs.file-max=65536" >> /etc/sysctl.conf
sysctl -p

# Update
apt-get update -y

# Install prerequisites
apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg unzip

# Docker repo & GPG
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose

usermod -aG docker ubuntu
systemctl start docker
systemctl enable docker

# Docker Compose YAML
cat <<EOF > /home/ubuntu/docker-compose.yml
version: '3.7'
services:
  sonarqube:
    image: sonarqube:lts
    container_name: sonarqube
    ports:
      - "9000:9000"
      - "9092:9092"
    environment:
      - SONAR_JDBC_URL=jdbc:postgresql://db:5432/sonarqube
      - SONAR_JDBC_USERNAME=sonaruser
      - SONAR_JDBC_PASSWORD=sonarpw
    volumes:
      - sonarqube_conf:/opt/sonarqube/conf
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_extensions:/opt/sonarqube/extensions
      - sonarqube_bundled-plugins:/opt/sonarqube/lib/bundled-plugins

  db:
    image: postgres:12
    container_name: sonarqube_db
    restart: unless-stopped
    environment:
      - POSTGRES_USER=sonaruser
      - POSTGRES_PASSWORD=sonarpw
      - POSTGRES_DB=sonarqube
    volumes:
      - sonarqube_db:/var/lib/postgresql10
      - postgressql_data:/var/lib/postgresql10/data

networks:
  sonarnet:
    driver: bridge

volumes:
  sonarqube_data:
  sonarqube_extensions:
  sonarqube_conf:
  sonarqube_bundled-plugins:
  sonarqube_db:
  postgressql_data:
EOF

cd /home/ubuntu
docker-compose up -d
