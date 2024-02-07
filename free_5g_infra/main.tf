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

# create nat gateways
module "nat-gateway" {
  source              = "../modules/nat-gateway"
  public_subnet_1_id  = module.vpc.public_subnet_1_id
  public_subnet_2_id  = module.vpc.public_subnet_2_id
  public_subnet_3_id  = module.vpc.public_subnet_3_id
  private_subnet_1_id = module.vpc.private_subnet_1_id
  private_subnet_2_id = module.vpc.private_subnet_2_id
  private_subnet_3_id = module.vpc.private_subnet_3_id
  internet_gateway     = module.vpc.internet_gateway
  vpc_id              = module.vpc.vpc_id
 
  
}


#create security groups
module "alb_security_group" {
  source = "../modules/security-groups"
  vpc_id = module.vpc.vpc_id
}           