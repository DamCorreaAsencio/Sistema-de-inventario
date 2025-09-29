resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "vpc-${var.environment}"
    Environment = var.environment
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "igw-${var.environment}"
    Environment = var.environment
  }
}

# Subredes públicas
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = var.az_a
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-subnet-a-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = var.az_b
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-subnet-b-${var.environment}"
    Environment = var.environment
  }
}

# Subredes privadas
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = var.az_a

  tags = {
    Name        = "private-subnet-a-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = var.az_b

  tags = {
    Name        = "private-subnet-b-${var.environment}"
    Environment = var.environment
  }
}

# Route Table pública
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "rt-public-${var.environment}"
    Environment = var.environment
  }
}

# Ruta hacia internet
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Asociar route table a subredes públicas
resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b_assoc" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}