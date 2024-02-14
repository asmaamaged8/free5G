variable "region" {}
variable "vpc_cidr" {}
variable "project_name" {}
variable "public1_subnet_cidr_block" {}
variable "public2_subnet_cidr_block" {}
variable "public3_subnet_cidr_block" {}
variable "private1_subnet_cidr_block" {}
variable "private2_subnet_cidr_block" {}
variable "private3_subnet_cidr_block" {}
#eks variabls 
variable "cluster_name" {}
variable "node_group_name"{}
variable "capacity_type"{}
variable "instance_types"{}
variable "desired_size"{}
variable "max_size"{}
variable "min_size"{}
variable "max_unavailable"{}
variable "oidc_issuer_url" {} 