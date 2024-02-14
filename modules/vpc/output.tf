output "region" {
  value = var.region
}

output "project_name" {
  value = var.project_name
}
output "vpc_id" {
  value = aws_vpc.asmaavpc.id
}
#################################
output "public_subnet_ids" {
  description = "The IDs of the created subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the created subnets"
  value       = aws_subnet.private[*].id
}

############################

output "internet_gateway" {
  value = aws_internet_gateway.igw.id
}