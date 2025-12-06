# Configure the AWS Provider
provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

# Un salpimentón de AWS en us-east-1 para CloudFront
provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
  profile = var.aws_profile
}

# Creo que aquí abajo va el viejillo jenkins, sino ver en dónde
