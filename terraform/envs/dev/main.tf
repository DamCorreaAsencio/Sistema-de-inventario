#Llamada al BCP (VPC)
module "vpc" {
  source = "../../modulos/vpc"

  project = "sistema-inventario-dev"
  region  = var.region

  vpc_cidr                  = "10.1.0.0/16"
  public_subnet_a_cidr      = "10.1.0.0/24"
  public_subnet_b_cidr      = "10.1.4.0/24"
  private_subnet_ec2_a_cidr = "10.1.1.0/24"
  private_subnet_ec2_b_cidr = "10.1.2.0/24"
  private_subnet_rds_cidr   = "10.1.3.0/24"
  private_subnet_rds_b_cidr = "10.1.5.0/24"

  az_a           = "us-east-2a"
  az_b           = "us-east-2b"
  endpoint_sg_id = module.security_groups.endpoint_sg_id
}

module "security_groups" {
  source      = "../../modulos/security_groups"
  vpc_id      = module.vpc.vpc_id
  project     = "sistemainventario"
  environment = "dev"
}

module "alb" {
  source         = "../../modulos/loadbalancer"
  project        = "sistemainventario"
  region         = var.region
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets_ids
  alb_sg_id      = module.security_groups.alb_sg_id
}

module "fargate_backend" {
  source              = "../../modulos/fargate"
  project             = "sistemainventario"
  region              = var.region
  account_id          = "251740340893"
  repo_name           = "sistemainventario-backend"

  cpu                 = 256
  memory              = 512
  desired_count       = 1

  private_subnet_ids  = module.vpc.private_subnets_ids
  ecs_sg_id           = module.security_groups.ec2_sg_id
  target_group_arn    = module.alb.target_group_arn
  lb_listener         = module.alb.listener_arn
}

module "apigateway" {
  source        = "../../modulos/apigateway"
  project       = "sistema-inventario"
  region        = var.region
  stage_name    = "dev"
  alb_dns_name  = module.alb.alb_dns_name
}