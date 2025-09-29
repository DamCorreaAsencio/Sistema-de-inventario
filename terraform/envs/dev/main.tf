module "vpc" {
  source = "../../modulos/vpc"

  vpc_cidr = "10.1.0.0/16"
  environment = "dev"

  public_subnet_a_cidr  = "10.1.0.0/24"
  private_subnet_a_cidr = "10.1.1.0/24"
  public_subnet_b_cidr  = "10.1.3.0/24"
  private_subnet_b_cidr = "10.1.2.0/24"

  az_a = "us-east-2a"
  az_b = "us-east-2b"
}

module "security_groups" {
  source     = "../../modulos/security_groups"
  vpc_id     = module.vpc.vpc_id
  environment = "dev"
}

module "ec2_backend" {
  source = "../../modulos/ec2"

  ami_id            = "ami-0ca4d5db4872d0c28" # Amazon Linux 2023
  instance_type     = "t2.micro"
  subnet_id         = module.vpc.private_subnet_ids[0]  # primera subred privada
  security_group_id = module.security_groups.ec2_sg_id # SG EC2
  key_name          = "dev-key"               # clave ya creada en AWS
  environment       = "dev"
}
