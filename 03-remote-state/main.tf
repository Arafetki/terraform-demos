resource "aws_vpc" "dev" {
  cidr_block         = var.vpc_cidr
  enable_dns_support = var.enable_dns
  instance_tenancy   = "default"

  tags = {
    Name = "Development VPC"
  }

}

# Internet gateway for internet connectivity
resource "aws_internet_gateway" "dev" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "Development IGW"
  }
}


# Default route table
resource "aws_default_route_table" "default_dev" {
  default_route_table_id = aws_vpc.dev.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev.id
  }

  tags = {
    Name = "Default RT"
  }
}

# Route table for private subnets
resource "aws_route_table" "local" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  tags = {
    Name = "RT Local"
  }
}
