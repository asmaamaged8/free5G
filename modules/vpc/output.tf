output "region" {
  value = var.region
}

output "project_name" {
  value = var.project_name
}
output "vpc_id" {
  value = aws_vpc.asmaavpc.id
}
output "public_subnet_1_id" {
  value = aws_subnet.public1.id
}
output "public_subnet_2_id" {
  value = aws_subnet.public2.id
}
output "public_subnet_3_id" {
  value = aws_subnet.public3.id
}
output "private_subnet_1_id" {
  value = aws_subnet.private1.id
}
output "private_subnet_2_id" {
  value = aws_subnet.private2.id
}
output "private_subnet_3_id" {
  value = aws_subnet.private2.id
}
output "internet_gateway" {
  value = aws_internet_gateway.igw.id
}