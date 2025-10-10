resource "aws_ecr_repository" "backend_repo" {
  name                 = "${var.project}-backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.project}-backend-ecr"
    Environment = var.environment
  }
}