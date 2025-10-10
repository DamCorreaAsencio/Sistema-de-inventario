# VPC principal
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project}-vpc"
  }
}

# Internet Gateway (solo para subnet pública)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project}-igw"
  }
}

# Subnets públicas (para ALB)
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.1.0.0/24"
  availability_zone       = var.az_a
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-public-a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.1.4.0/24"
  availability_zone       = var.az_b
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-public-b"
  }
}

# Subnets privadas para EC2
resource "aws_subnet" "private_ec2_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_ec2_a_cidr
  availability_zone = var.az_a
  tags = { Name = "${var.project}-private-ec2-a" }
}

resource "aws_subnet" "private_ec2_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_ec2_b_cidr
  availability_zone = var.az_b
  tags = { Name = "${var.project}-private-ec2-b" }
}

# Subnet privada para RDS
resource "aws_subnet" "private_rds" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_rds_cidr
  availability_zone = var.az_b
  tags = { Name = "${var.project}-private-rds" }
}

# ROUTE TABLES
# Pública (con salida a Internet)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "${var.project}-public-rt" }
}

# Privada (sin NAT, solo interna)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  tags = { Name = "${var.project}-private-rt" }
}

# ASOCIACIONES DE ROUTE TABLES
resource "aws_route_table_association" "public_assoc_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_assoc_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_ec2_a_assoc" {
  subnet_id      = aws_subnet.private_ec2_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_ec2_b_assoc" {
  subnet_id      = aws_subnet.private_ec2_b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_rds_assoc" {
  subnet_id      = aws_subnet.private_rds.id
  route_table_id = aws_route_table.private.id
}

# VPC ENDPOINTS
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private_ec2_a.id, aws_subnet.private_ec2_b.id]
  private_dns_enabled = true
  tags = { Name = "${var.project}-ecr-api-endpoint" }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private_ec2_a.id, aws_subnet.private_ec2_b.id]
  private_dns_enabled = true
  tags = { Name = "${var.project}-ecr-dkr-endpoint" }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id]
  tags = { Name = "${var.project}-s3-endpoint" }
}