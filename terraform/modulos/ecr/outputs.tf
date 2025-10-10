output "repository_url" {
  description = "URL del repositorio ECR"
  value       = aws_ecr_repository.backend_repo.repository_url
}