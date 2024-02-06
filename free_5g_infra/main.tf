# aws provider
provider "aws" {
  region = var.region
}

# create vpc
module "vpc" {
  source                     = "../modules/vpc"
  region                     = var.region
  vpc_cidr                   = var.vpc_cidr
  project_name               = var.project_name
  public1_subnet_cidr_block  = var.public1_subnet_cidr_block
  public2_subnet_cidr_block  = var.public2_subnet_cidr_block
  public3_subnet_cidr_block  = var.public3_subnet_cidr_block
  private1_subnet_cidr_block = var.private1_subnet_cidr_block
  private2_subnet_cidr_block = var.private2_subnet_cidr_block
  private3_subnet_cidr_block = var.private3_subnet_cidr_block
}

