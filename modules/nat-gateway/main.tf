# Elastic IPs
resource "aws_eip" "nat" {
  count = length(var.private_subnet_ids)

  tags = {
    Name = "eip-${count.index + 1}"
  }
}

# NAT Gateways
resource "aws_nat_gateway" "nat" {
  count         = length(var.private_subnet_ids)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = var.private_subnet_ids[count.index]
  depends_on    = [aws_eip.nat]

  tags = {
    Name = "nat-${count.index + 1}"
  }
}


# Create a route table for each private subnet
resource "aws_route_table" "private_route_table" {
  count  = length(var.private_subnet_ids)
  vpc_id = var.vpc_id

  tags = {
    Name = "private-route-table-${count.index + 1}"
  }
}

# Create a route in each private route table to route traffic through the NAT gateway
resource "aws_route" "private_route" {
  count              = length(var.private_subnet_ids)
  route_table_id     = aws_route_table.private_route_table[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id     = aws_nat_gateway.nat[count.index].id
}

# Associate each private subnet with its respective route table
resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnet_ids)
  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private_route_table[count.index].id
}