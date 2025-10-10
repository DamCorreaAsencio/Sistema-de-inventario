resource "aws_launch_template" "backend_lt" {
  name_prefix   = "${var.project}-backend-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [var.ec2_sg_id]

  user_data = base64encode(<<EOF
                        #!/bin/bash
                        REGION="${var.region}"
                        ACCOUNT_ID="${var.account_id}"
                        REPO_NAME="${var.repo_name}"

                        # Instalar Docker
                        apt-get update -y
                        apt-get install -y docker.io

                        # Iniciar Docker
                        systemctl start docker
                        systemctl enable docker

                        # Login a ECR
                        aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $${ACCOUNT_ID}.dkr.ecr.$${REGION}.amazonaws.com

                        # Descargar e iniciar contenedor backend
                        docker pull $${ACCOUNT_ID}.dkr.ecr.$${REGION}.amazonaws.com/$${REPO_NAME}:latest
                        docker run -d -p 80:80 $${ACCOUNT_ID}.dkr.ecr.$${REGION}.amazonaws.com/$${REPO_NAME}:latest
                        EOF
                    )

    tag_specifications {
        resource_type = "instance"
        tags = {
        Name = "${var.project}-backend"
        }
    }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "backend_asg" {
  name                      = "${var.project}-asg"
  desired_capacity           = 2
  min_size                   = 2
  max_size                   = 4
  vpc_zone_identifier        = var.private_subnet_ids
  launch_template {
    id      = aws_launch_template.backend_lt.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]

  tag {
    key                 = "Name"
    value               = "${var.project}-backend-asg"
    propagate_at_launch = true
  }
}