variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "eu-west-2" # London
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  default = "klinik-vpc"
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

variable "ami_id" {
  default = "ami-044415bb13eee2391"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "webserver_keypair" {
  default = "klinik-web-keypair"
}

variable "allocated_storage" {
  default = 20
}

variable "db_username" {
  default   = "admin"
  sensitive = true
}

variable "db_password" {
  default   = "Your_db_pwd"
  sensitive = true
}

variable "jenkins_keypair" {
  type        = string
  default     = "klinik-jenkins-keypair"
  description = "Key-pair for Jenkins EC2 instance"
}

variable "monitoring_keypair" {
  default     = "klinik-prometheus-keypair"
  description = "Key pair name"
  type        = string
}

variable "sonarqube_keypair" {
  default     = "klinik-sonarqube-keypair"
  description = "Key pair name"
  type        = string
}
