# Llamada al módulo de VPC
module "vpc" {
  source = "../../modulos/vpc"

  project  = "sistema-inventario-dev"
  region       = var.region

  vpc_cidr                 = "10.1.0.0/16"
  public_subnet_cidr       = "10.1.0.0/24"
  private_subnet_ec2_a_cidr = "10.1.1.0/24"
  private_subnet_ec2_b_cidr = "10.1.2.0/24"
  private_subnet_rds_cidr   = "10.1.3.0/24"

  az_a = "us-east-2a"
  az_b = "us-east-2b"
}

module "security_groups" {
  source      = "../../modulos/security_groups"
  vpc_id      = module.vpc.vpc_id
  project     = "sistemainventario"
  environment = "dev"
}