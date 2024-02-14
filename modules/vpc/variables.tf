variable "region" {}
variable "vpc_cidr" {}
variable "project_name" {}

variable "public_subnet_cidr_blocks" {
    type = list(string)
}

variable "private_subnet_cidr_blocks" {
    type = list(string)
}
