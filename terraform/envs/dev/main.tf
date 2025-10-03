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

module "security_groups" {
  source      = "../../modulos/security_groups"
  vpc_id      = module.vpc.vpc_id
  environment = "dev"
}