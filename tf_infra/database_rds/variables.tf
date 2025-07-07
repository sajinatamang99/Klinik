variable "allocated_storage" {
  type        = number
  default     = "20"
  description = "provide storagein GB"
}

variable "db_username" {
  type    = string
  default = "Your_username"
}
variable "db_password" {
  type    = string
  default = "Your_password"
}

variable "vpc_id" {
  description = "VPC ID for the RDS instance and SG"
  type        = string
}
variable "db_subnet_ids" {
  type = list(string)
}

variable "vpc_security_group_ids" {
  type = list(string)
}