
# create security group for the application load balancer 
resource "aws_security_group" "alb_security_group" {
  name        = "alb-security-group"
  description = "security group for web servers"
  vpc_id = var.vpc_id

  // Define ingress rules (inbound traffic)
  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from any IPv4 address
  }

  ingress {

    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allowing SSH access from any IPv4 address
  }

  // Define egress rules (outbound traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic to any IPv4 address
  }
  tags = {
    Name ="alb_security_group"
  }
}


# create security group for eks
resource "aws_security_group" "eks_security_group" {
  name        = "eks-security-group"
  description = "security group for eks"
  vpc_id = var.vpc_id

  // Define ingress rules (inbound traffic)
  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_security_group.alb_security_group.id]  # Allow traffic from any IPv4 address
  }

  ingress {

    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_security_group.alb_security_group.id]  # Allowing SSH access from any IPv4 address
  }

  // Define egress rules (outbound traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic to any IPv4 address
  }
  tags = {
    Name = "eks_security_group"
  }
}