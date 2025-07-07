variable "ami_id" {
  type        = string
  default     = "ami-044415bb13eee2391"
  description = "AMI for the instance"
}
variable "vpc_id" {
  type = string
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Instance type"
}

variable "webserver_keypair" {
  type        = string
  default     = "klinik-web-keypair"
  description = "Key-pair for web server Ec2 "
}
variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs to launch web servers"
  type        = list(string)
}

variable "webserver_sg_id" {
  description = "Security group ID for the web server"
  type        = list(string)
}

variable "web_alb_sg" {
  description = "Security group ID for the web server"
  type        = string
}
