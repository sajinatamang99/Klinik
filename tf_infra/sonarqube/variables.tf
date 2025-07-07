variable "ami_id" {
  type    = string
  default = "ami-044415bb13eee2391" # Ubuntu 22.04 LTS (eu-west-2)
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "key_name" {
  type    = string
  default = "klinik-sonarqube-keypair"
}

variable "public_subnet_id" {
  type = string
}

variable "sonarqube_sg_ids" {
  type = list(string)
}

variable "rds_endpoint" {
  type = string
}

variable "rds_username" {
  type = string
}

variable "rds_password" {
  type = string
}
