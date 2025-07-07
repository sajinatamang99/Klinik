# AWS Provider and Region Setup
provider "aws" {
  region = var.aws_region # Change to your preferred AWS region
}

# Global data sources
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

module "global" {
  source          = "./global"
  vpc_cidr        = var.vpc_cidr
  vpc_name        = var.vpc_name
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}

module "compute_ec2" {
  source             = "./compute_ec2"
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  webserver_keypair  = var.webserver_keypair
  vpc_id             = module.global.vpc_id
  private_subnet_ids = module.global.private_subnet_ids
  public_subnet_ids  = module.global.public_subnet_ids
  webserver_sg_id    = [module.global.webserver_sg_id]
  web_alb_sg         = module.global.web_alb_sg
}

module "database_rds" {
  source                 = "./database_rds"
  allocated_storage      = var.allocated_storage
  db_username            = var.db_username
  db_password            = var.db_password
  vpc_id                 = module.global.vpc_id
  db_subnet_ids          = module.global.private_subnet_ids
  vpc_security_group_ids = [module.global.rds_sg, module.global.webserver_sg]
}

module "jenkins" {
  source           = "./jenkins"         # Path to your Jenkins module
  ami_id           = var.ami_id          # Pass AMI id variable
  instance_type    = var.instance_type   # Pass instance type variable
  jenkins_keypair  = var.jenkins_keypair # Pass keypair variable
  jenkins_sg_id    = [module.global.jenkins_sg_id, module.global.webserver_sg]
  public_subnet_id = module.global.public_subnets["public_subnet_1"]
}

module "prometheus" {
  source               = "./prometheus"
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  monitoring_keypair   = var.monitoring_keypair
  monitoring_sg_ids    = [module.global.monitoring_sg, module.global.webserver_sg] # Assuming you exported these SG IDs from global module
  monitoring_subnet_id = module.global.public_subnets["public_subnet_1"]           # Or whichever subnet you want to use
}

module "sonarqube" {
  source           = "./sonarqube"
  key_name         = var.sonarqube_keypair
  public_subnet_id = module.global.public_subnets["public_subnet_1"]
  sonarqube_sg_ids = [module.global.sonarqube_sg, module.global.webserver_sg]

  rds_endpoint = module.database_rds.sonar_db_endpoint
  rds_username = module.database_rds.sonar_db_username
  rds_password = module.database_rds.sonar_db_password
}

