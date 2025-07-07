#Create a EC2 instance to host the Klinik web server with the below specifications
resource "aws_launch_template" "webserver_lt" {
  name_prefix            = "klinik-webserver"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.webserver_keypair
  vpc_security_group_ids = var.webserver_sg_id
  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt update
    apt install -y apache2

    # Clone your app from GitHub
    cd /opt
    git clone https://github.com/sajinatamang99/Klinik.git
   
    # Remove the apache index/default page
    rm -rf /var/www/html/*
    # Copy or symlink to Apache web root:
    cp -r /opt/Klinik/app/* /var/www/html/
    chown -R www-data:www-data /var/www/html

    systemctl enable apache2
    systemctl restart apache2

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
  )
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "klinik-webserver"
    }
  }
  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }
}

resource "aws_autoscaling_group" "web_asg" {
  name                      = "klinik-webserver-asg"
  min_size                  = 2
  max_size                  = 4
  desired_capacity          = 2
  vpc_zone_identifier       = var.private_subnet_ids
  target_group_arns         = [aws_lb_target_group.web_target_group.arn]
  health_check_type         = "EC2"
  health_check_grace_period = 120
  launch_template {
    id      = aws_launch_template.webserver_lt.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "klinik-webserver"
    propagate_at_launch = true
  }
}

resource "aws_lb" "web_alb" {
  name               = "klinik-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.web_alb_sg]

  subnets = var.public_subnet_ids
  tags = {
    Name = "klinik-alb"
  }
}

resource "aws_lb_target_group" "web_target_group" {
  name     = "klinik-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }
}
