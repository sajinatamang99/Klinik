resource "aws_ecr_repository" "ecr_klinik_repo" {
  name                 = "eks-klinik"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Environment = "dev"
    Project     = "klinik"
  }
}
