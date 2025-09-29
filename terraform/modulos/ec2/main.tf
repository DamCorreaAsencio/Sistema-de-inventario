resource "aws_instance" "backend" {
  ami           = var.ami_id           # AMI de Ubuntu
  instance_type = var.instance_type    # tipo t2.micro para free tier
  subnet_id     = var.subnet_id        # subred pública
  vpc_security_group_ids = [var.security_group_id]  # SG de EC2

  key_name = var.key_name  # par de llaves para conectarte por SSH

  tags = {
    Name        = "ec2-backend-${var.environment}"
    Environment = var.environment
  }
}
