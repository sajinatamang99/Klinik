resource "aws_instance" "sonarqube" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = var.sonarqube_sg_ids
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/install-sonarqube.sh", {
    db_endpoint = var.rds_endpoint,
    db_user     = var.rds_username,
    db_pass     = var.rds_password
  })

  tags = {
    Name = "klinik-sonarqube"
  }
}
