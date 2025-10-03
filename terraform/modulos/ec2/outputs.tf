output "backend_lt_id" {
  value = aws_launch_template.backend.id
}

output "asg_name" {
  value = aws_autoscaling_group.backend.name
}