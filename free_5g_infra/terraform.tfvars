region                     = "us-east-1"
project_name               = "free5G"

vpc_cidr                   = "10.0.0.0/16"
public1_subnet_cidr_block  = "10.0.0.0/24"
public2_subnet_cidr_block  = "10.0.1.0/24"
public3_subnet_cidr_block  = "10.0.2.0/24"
private1_subnet_cidr_block = "10.0.3.0/24"
private2_subnet_cidr_block = "10.0.4.0/24"
private3_subnet_cidr_block = "10.0.5.0/24"
###############################################
public_subnet_cidr_blocks = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"]

private_subnet_cidr_blocks = [
  "10.0.4.0/24",
  "10.0.5.0/24",
  "10.0.6.0/24"]
##############################################3
cluster_name = "asmaa-5g-cluster"
capacity_type = "ON_DEMAND"
instance_types = ["t3.small"]
desired_size = 1
max_size = 5
min_size = 1
max_unavailable = 0
node_group_name = "asmaa-5g-node-group"
#oidc_issuer_url = 

