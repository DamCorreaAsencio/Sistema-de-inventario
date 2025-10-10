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

# Security Group para las instancias EC2
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project}-ec2-sg"
  description = "Permite tráfico desde el ALB y salida hacia RDS y otros servicios internos"
  vpc_id      = var.vpc_id

  # Tráfico interno desde ALB
  ingress {
    description     = "HTTP desde ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description     = "HTTPS desde ALB"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Sin SSH ni acceso externo, evita exposición y costos
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-ec2-sg"
    Environment = var.environment
  }
}

# Security Group para la base de datos RDS
resource "aws_security_group" "rds_sg" {
  name        = "${var.project}-rds-sg"
  description = "Permite MySQL solo desde las instancias EC2"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL desde EC2 SG"
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