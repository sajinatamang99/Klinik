terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "tf-klinik-s3-backend"
    key            = "tf_infra/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "klinik-table-locks"
    encrypt        = true
  }
}
