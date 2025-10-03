# Repositorio ECR para las imágenes del backend
resource "aws_ecr_repository" "backend_repo" {
  name                 = "${var.project}-backend-${var.environment}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.project}-backend-repo"
    Environment = var.environment
  }

  lifecycle {
    prevent_destroy = true
  }
  
}