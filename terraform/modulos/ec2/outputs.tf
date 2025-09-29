output "ec2_public_ip" {
  description = "IP pública de la EC2"
  value       = aws_instance.backend.public_ip
}