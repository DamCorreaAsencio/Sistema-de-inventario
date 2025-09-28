module "vpc" {
  source = "../../modulos/vpc"

  vpc_cidr = "10.1.0.0/16"
  environment = "dev"
}


/*resource "aws_vpc" "vpc" {
  cidr_block       = "10.1.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}

provider "docker" {
}

# terraform init
# terraform workspace list
# terraform workspace new dev
# terraform plan
# terraform apply -auto-approve
# terraform destroy

module "vpc" {
  source          = "../../modules/vpc"
  project         = "inventario"
  env             = "dev"
  vpc_cidr        = "10.1.0.0/16"
  public_subnets  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnets = ["10.1.3.0/24", "10.1.4.0/24"]
  azs             = ["us-east-2a", "us-east-2b"]
} */