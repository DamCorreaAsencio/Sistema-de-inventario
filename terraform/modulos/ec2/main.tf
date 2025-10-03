resource "aws_launch_template" "backend" {
  name_prefix   = "sis-inv-backend-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [var.security_group_id]
}

resource "aws_autoscaling_group" "backend" {
  desired_capacity    = 2
  max_size            = 2
  min_size            = 2
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "sis-inv-backend"
    propagate_at_launch = true
  }
}