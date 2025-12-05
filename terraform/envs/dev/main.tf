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

# RDS Multi
module "rds" {
  source = "../../modulos/rdsmulti"

  project     = "sistemainventario"
  environment = "dev"
  region      = var.region 

  rds_subnet_ids = module.vpc.rds_subnet_ids
  rds_sg_id      = module.security_groups.rds_sg_id

  instance_class    = "db.t3.micro" 
  allocated_storage = 20
  db_name           = "inventario"
  db_username       = var.db_username
  db_password       = var.db_password

#
#Lo que viene está medio waos. En skip_final... y deletion_protection se invierten los true y false en producción
#
  skip_final_snapshot = true 
  deletion_protection = false

  depends_on = [module.vpc, module.security_groups]
}

# CloudWatch (Monitoreo y Logs)
module "cloudwatch" {
  source = "../../modulos/cloudwatch"

  project     = "sistemainventario"
  environment = "dev"
  region      = var.region

  ecs_cluster_name = module.fargate_backend.cluster_id
  ecs_service_name = module.fargate_backend.service_name
  rds_instance_id  = module.rds.rds_address
  alb_arn_suffix   = module.alb.alb_arn_suffix

  log_retention_days = 7

  # Umbrales de alarmas
  ecs_cpu_threshold     = 80
  ecs_memory_threshold  = 80
  rds_cpu_threshold     = 80
  rds_storage_threshold = 5368709120 

  depends_on = [module.fargate_backend, module.rds, module.alb]
}

# WAF (Firewall de Aplicación Web)
module "waf" {
  source = "../../modulos/waf"

  project     = "sistemainventario"
  environment = "dev"

#  blocked_ip_addresses = []

  # Rate limiting: máximo 2000 peticiones por IP cada 5 minutos
  rate_limit = 2000
  enable_linux_protection = true
  enable_logging          = false # Activar cuando se teng a S3/Kinesis configurado
}

# CloudFront (CDN para Frontend)
module "cloudfront" {
  source = "../../modulos/cloudfront"

  project     = "sistemainventario"
  environment = "dev"

  api_gateway_domain = module.apigateway.api_gateway_domain
  waf_acl_id         = module.waf.web_acl_id

  # domain_name = "notengodominio.com"

  price_class = "PriceClass_100" # Más económico

  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  depends_on = [module.apigateway, module.waf]
}

# Route53 (DNS) - Solo si tienes dominio
module "route53" {
  source = "../../modulos/route53"

  project     = "sistemainventario"
  environment = "dev"

  # Configurar si se tiene dominio (algún día):
  # domain_name              = "tudominio.com"
  # subdomain                = "app"  # app.tudominio.com
  # api_subdomain            = "api"  # api.tudominio.com
  # cloudfront_domain_name   = module.cloudfront.cloudfront_domain_name
  # api_gateway_domain       = module.apigateway.api_gateway_domain
  # enable_health_check      = true
#  domain_name = ""

  depends_on = [module.cloudfront]
}