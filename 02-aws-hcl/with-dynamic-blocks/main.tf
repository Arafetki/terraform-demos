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


# A public subnet
resource "aws_subnet" "web" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = var.subnets_cidr_blocks[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "Web Subnet"
  }
}

# A private subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.dev.id
  cidr_block        = var.subnets_cidr_blocks[1]
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "Private Subnet"
  }

}

# Route table association
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.local.id
}


# Ami for Ec2 instances
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

# Web Access SG
resource "aws_security_group" "web" {
  name        = "web access"
  vpc_id      = aws_vpc.dev.id
  description = "allow http and https traffic"

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Web Access SG"
  }

}

# SSH key pair
resource "aws_key_pair" "web" {
  key_name   = "terrademo"
  public_key = file(var.ssh_public_key)
}

# Ec2 instances for web servers
resource "aws_instance" "web_apache" {
  subnet_id       = aws_subnet.web.id
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.web.key_name
  security_groups = [aws_security_group.web.id]
  count           = 2
  user_data       = file(var.apache_user_data)

  tags = {
    Name = "Apache Web Server"
  }

}


