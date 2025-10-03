# Nombre del repositorio ECR
output "repository_name" {
  description = "Repo backend en ECR"
  value       = aws_ecr_repository.backend_repo.name
}

# URL del repositorio (para hacer docker push)
output "repository_url" {
  description = "URI del repo ECR (registry/repo)"
  value       = aws_ecr_repository.backend_repo.repository_url
}