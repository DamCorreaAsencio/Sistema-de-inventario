# Llamada al módulo de VPC
module "vpc" {
  source = "../../modulos/vpc"

  project = "sistema-inventario-dev"
  region  = var.region

  vpc_cidr                 = "10.1.0.0/16"
  public_subnet_a_cidr     = "10.1.0.0/24"
  public_subnet_b_cidr     = "10.1.4.0/24"
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

module "ecr" {
  source      = "../../modulos/ecr"
  project     = "sistemainventario"
  environment = "dev"
}

module "alb" {
  source        = "../../modulos/loadbalancer"
  project       = "sistemainventario"
  region        = var.region
  vpc_id        = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets_ids
  alb_sg_id     = module.security_groups.alb_sg_id
}

module "ec2_backend" {
  source = "../../modulos/ec2"
  project            = "sistemainventario"
  region             = var.region
  account_id         = "273354649672"
  repo_name          = "sistemainventario-backend"
  ami_id             = "ami-0d9a665f802ae6227" # Ubuntu 22.04 LTS oficial (us-east-2)
  instance_type      = "t2.micro"
  key_name           = "dev-key"
  private_subnet_ids = module.vpc.private_subnets_ids
  ec2_sg_id          = module.security_groups.ec2_sg_id
  target_group_arn   = module.alb.target_group_arn
}