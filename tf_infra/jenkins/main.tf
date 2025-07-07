#Create a EC2 instance to host the Klinik web server with the below specifications
resource "aws_instance" "jenkins_server" {
  key_name               = var.jenkins_keypair
  ami                    = var.ami_id        # Replace with your region-specific AMI ID
  instance_type          = var.instance_type # Replace with your instance-type
  depends_on             = [var.jenkins_sg_id, var.public_subnet_id]
  vpc_security_group_ids = var.jenkins_sg_id
  subnet_id              = var.public_subnet_id

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y openjdk-17-jdk
    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt update -y
    sudo apt install -y jenkins
    sudo systemctl enable jenkins
    sudo systemctl start jenkins

    # --- Install Node Exporter ---
    useradd --no-create-home --shell /bin/false node_exporter

    cd /tmp
    NODE_EXPORTER_VERSION="1.8.0"
    wget https://github.com/prometheus/node_exporter/releases/download/v$${NODE_EXPORTER_VERSION}/node_exporter-$${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
    tar xvf node_exporter-$${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
    cp node_exporter-$${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin/
    chown node_exporter:node_exporter /usr/local/bin/node_exporter

    # Create systemd service
    cat <<EOT | tee /etc/systemd/system/node_exporter.service
    [Unit]
    Description=Node Exporter
    Wants=network-online.target
    After=network-online.target

    [Service]
    User=node_exporter
    Group=node_exporter
    Type=simple
    ExecStart=/usr/local/bin/node_exporter

    [Install]
    WantedBy=multi-user.target
    EOT

    systemctl daemon-reload
    systemctl enable node_exporter
    systemctl start node_exporter
    EOF

  tags = {
    Name        = "klinik-jenkins"  # This is the instance name in AWS
    Environment = "jenkins-staging" # Optional additional tags
  }
  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }
  root_block_device {
    encrypted = true
  }
}