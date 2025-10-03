# Llamada al módulo de VPC
module "vpc" {
  source = "../../modulos/vpc"

  project  = "sistema-inventario-dev"
  vpc_cidr = "10.1.0.0/16"

  # Zonas de disponibilidad en us-east-2
  azs = ["us-east-2a", "us-east-2b"]

  # Subnets públicas (para ALB, NAT Gateway)
  public_subnets = ["10.1.0.0/24", "10.1.3.0/24"]

  # Subnets privadas (para EC2 backend, RDS)
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
}

# llamada al modulo security_groups
module "security_groups" {
  source      = "../../modulos/security_groups"
  vpc_id      = module.vpc.vpc_id
  environment = "dev"
}

# Módulo ECR - repositorio para la imagen backend
module "ecr" {
  source      = "../../modulos/ecr"
  project     = "sistema-inventario"
  environment = "dev"
}

output "repository_url" {
  value = module.ecr.repository_url
}

output "repository_name" {
  value = module.ecr.repository_name
}

# llamda al modulo ec2
module "ec2" {
  source            = "../../modulos/ec2"
  ami_id            = "ami-0ca4d5db4872d0c28" # Amazon Linux 2 en us-east-2
  instance_type     = "t2.micro"
  key_name          = "dev-key"
  security_group_id = module.security_groups.ec2_sg_id
  subnet_ids        = module.vpc.private_subnets_ids
}