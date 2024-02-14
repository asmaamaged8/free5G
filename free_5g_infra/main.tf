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

# create iam roles and eks 
module "eks" {
  source = "../modules/eks"
  cluster_name  = var.cluster_name
  eks_security_group_id= module.alb_security_group.eks_security_group_id
  node_group_name = var.node_group_name
  capacity_type  = var.capacity_type
  instance_types = var.instance_types
  desired_size   = var.desired_size
  max_size       = var.max_size
  min_size       = var.min_size
  max_unavailable = var.max_unavailable
  private_subnet_1_id = module.vpc.private_subnet_1_id
  private_subnet_2_id = module.vpc.private_subnet_2_id
  private_subnet_3_id = module.vpc.private_subnet_3_id    
  oidc_issuer_url = var.oidc_issuer_url
} 

#create an alb
module "application_load_balancer" {
  source = "../modules/alb"
  project_name = module.vpc.project_name
  alb_security_group_id = module.alb_security_group.alb_security_group_id
  private_subnet_1_id = module.vpc.private_subnet_1_id
  private_subnet_2_id = module.vpc.private_subnet_2_id
  private_subnet_3_id = module.vpc.private_subnet_3_id
  vpc_id = module.vpc.vpc_id
  tls_certificate_arn = module.eks.tls_certificate_arn
}