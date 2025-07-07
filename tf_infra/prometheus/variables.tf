variable "ami_id" {
  default     = "ami-044415bb13eee2391"
  description = "AMI ID for Ubuntu"
  type        = string
}

variable "instance_type" {
  default     = "t2.micro"
  description = "Instance type"
  type        = string
}

variable "monitoring_keypair" {
  default     = "klinik-prometheus-keypair"
  description = "Key pair name"
  type        = string
}

variable "monitoring_sg_ids" {
  type = list(string)
}
variable "monitoring_subnet_id" {
  description = "List of subnet IDs to deploy monitoring instances (Prometheus/Grafana)"
  type        = string
}