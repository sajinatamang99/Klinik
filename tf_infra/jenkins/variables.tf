variable "ami_id" {
  type        = string
  default     = "ami-044415bb13eee2391"
  description = "AMI for the instance"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Instance type"
}

variable "jenkins_keypair" {
  type        = string
  default     = "klinik-jenkins-keypair"
  description = "Key-pair for web server Ec2 "
}
variable "jenkins_sg_id" {
  description = "The security group ID for Jenkins"
  type        = list(string)
}
variable "public_subnet_id" {
  type = string
}