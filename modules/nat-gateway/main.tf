##eip
resource "aws_eip" "eip1" {

}

resource "aws_eip" "eip2" {

}

resource "aws_eip" "eip3" {

}

#ngw
resource "aws_nat_gateway" "ngw1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = var.public_subnet_1_id
  depends_on    = [aws_eip.eip1, var.internet_gateway]

}
resource "aws_nat_gateway" "ngw2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = var.public_subnet_2_id
  depends_on    = [aws_eip.eip2, var.internet_gateway]

}
resource "aws_nat_gateway" "ngw3" {
  allocation_id = aws_eip.eip3.id
  subnet_id     = var.public_subnet_3_id
  depends_on    = [aws_eip.eip3, var.internet_gateway]




  ###################################################
}
 resource "aws_route_table" "privatea" {
  vpc_id = var.vpc_id

}
resource "aws_route" "private_route_a" {
  route_table_id = aws_route_table.privatea.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.ngw1.id
}
resource "aws_route_table_association" "private1" {
  subnet_id      = var.private_subnet_1_id
  route_table_id = aws_route_table.privatea.id
}




resource "aws_route_table" "privateb" {
  vpc_id = var.vpc_id

}
resource "aws_route" "private_route_b" {
  route_table_id = aws_route_table.privateb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.ngw2.id
}
resource "aws_route_table_association" "private2" {
  subnet_id      = var.private_subnet_2_id
  route_table_id = aws_route_table.privateb.id
}




resource "aws_route_table" "privatec" {
  vpc_id = var.vpc_id

}
resource "aws_route" "private_route_c" {
  route_table_id = aws_route_table.privatec.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.ngw3.id
}
resource "aws_route_table_association" "private3" {
  subnet_id      = var.private_subnet_3_id
  route_table_id = aws_route_table.privatec.id
}