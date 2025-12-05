# Security Group para el Load Balancer (ALB)
resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-alb-sg"
  description = "Permite HTTP/HTTPS desde Internet hacia el ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP desde Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS desde Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Salida general
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-alb-sg"
    Environment = var.environment
  }
}
//******************************************************************************************************//
#Acceso a los endpoints de la SG
resource "aws_security_group" "endpoint_sg" {
  name        = "${var.project}-endpoint-sg"
  description = "Permite HTTPS para endpoints de VPC"
  vpc_id      = var.vpc_id

  ingress {
    description = "Permite que ECS/Fargate acceda a los endpoints"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.ec2_sg.id] ##En teoría debería ser fargate a endpoints xd
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { 
    Name        = "${var.project}-endpoint-sg"
    Environment = var.environment
  }
}

# Security Group para la base de datos RDS
resource "aws_security_group" "rds_sg" {
  name        = "${var.project}-rds-sg"
  description = "Permite MySQL solo desde las tareas de Fargate"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL desde Fargate"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-rds-sg"
    Environment = var.environment
  }
}
//******************************************************************************************************//
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project}-ecs-sg"
  description = "Security group para tareas Fargate"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP desde ALB"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-fargate-sg"
    Environment = var.environment
  }
}