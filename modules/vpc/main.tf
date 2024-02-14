resource "aws_vpc" "asmaavpc" {
  cidr_block = var.vpc_cidr

  enable_dns_support = "true"


  tags = {
    Name = "${var.project_name}-vpc"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.asmaavpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

#subnets
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.asmaavpc.id
  cidr_block = var.public1_subnet_cidr_block
  map_public_ip_on_launch = true
  availability_zone = "${var.region}_a"
  
  tags = {
    Name = "${var.project_name}-public-subnet1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.asmaavpc.id
  cidr_block = var.public2_subnet_cidr_block
  map_public_ip_on_launch = true
  availability_zone = "${var.region}_b"
    tags = {
    Name = "${var.project_name}-public-subnet2"
  }
}

resource "aws_subnet" "public3" {
  vpc_id     = aws_vpc.asmaavpc.id
  cidr_block = var.public3_subnet_cidr_block
  map_public_ip_on_launch = true
  availability_zone = "${var.region}_c"
   tags = {
    Name = "${var.project_name}-public-subnet3"
  }
}

resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.asmaavpc.id
  cidr_block = var.private1_subnet_cidr_block
  availability_zone = "${var.region}_a"
     tags = {
    Name = "${var.project_name}-private-subnet1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.asmaavpc.id
  cidr_block = var.private2_subnet_cidr_block
  availability_zone = "${var.region}_b"
    tags = {
    Name = "${var.project_name}-private-subnet2"
  }
}

resource "aws_subnet" "private3" {
  vpc_id     = aws_vpc.asmaavpc.id
  cidr_block = var.private3_subnet_cidr_block
  availability_zone = "${var.region}_c"
  tags = {
    Name = "${var.project_name}-private-subnet3"
  }
}
#


#routetables

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.asmaavpc.id

}
resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public3" {
  subnet_id      = aws_subnet.public3.id
  route_table_id = aws_route_table.public.id
}

