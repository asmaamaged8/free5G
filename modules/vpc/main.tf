resource "aws_vpc" "asmaavpc" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true


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
###############################

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.asmaavpc.id
  count = length(var.public_subnet_cidr_blocks)
  cidr_block     = var.public_subnet_cidr_blocks[count.index]
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[count.index]
  
  
  tags = {
    Name = "${var.project_name}-public-subnet${count.index + 1}"
  }
}


resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.asmaavpc.id
  count = length(var.private_subnet_cidr_blocks)
  cidr_block     = var.private_subnet_cidr_blocks[count.index]
  map_public_ip_on_launch = false
  availability_zone = data.aws_availability_zones.available.names[count.index]

  
  tags = {
    Name = "${var.project_name}-private-subnet${count.index + 1}"
  }
}
################################


#routetables

#Route Table Association


resource "aws_route_table" "public_route_table" {
  count          = length(var.public_subnet_cidr_blocks)
  vpc_id = aws_vpc.asmaavpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "PUBLIC_route-${count.index + 1}"
  }
}

  resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_route_table[count.index].id

}



