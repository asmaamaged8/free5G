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

  ################
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  ##############
}

# create nat gateways
module "nat-gateway" {
  source              = "../modules/nat-gateway"
  
  internet_gateway    = module.vpc.internet_gateway
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
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
  #oidc_issuer_url = var.oidc_issuer_url

  #################################
  private_subnet_ids = module.vpc.private_subnet_ids
  #################################
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
  ##############
  private_subnet_ids = module.vpc.private_subnet_ids
}