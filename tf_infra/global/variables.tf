variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "eu-west-2" # London
}
variable "vpc_name" {
  type    = string
  default = "staging_vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  default = {
    "private_subnet_1" = 0
    "private_subnet_2" = 1
  }
}

variable "public_subnets" {
  default = {
    "public_subnet_1" = 0
    "public_subnet_2" = 1
  }
}
output "web_alb_sg" {
  value = aws_security_group.web_alb_sg.id
}

output "rds_sg" {
  value = aws_security_group.rds_sg.id
}

output "webserver_sg" {
  value = aws_security_group.webserver_sg.id
}

output "monitoring_sg" {
  value = aws_security_group.monitoring_sg.id
}

output "sonarqube_sg" {
  value = aws_security_group.sonarqube_sg.id
}

output "jenkins_sg" {
  value = aws_security_group.jenkins_sg.id
}
output "public_subnets" {
  value = {
    public_subnet_1 = aws_subnet.public_subnets["public_subnet_1"].id
    public_subnet_2 = aws_subnet.public_subnets["public_subnet_2"].id
  }
}
