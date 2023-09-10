resource "aws_vpc" "production" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "Production VPC"
  }
}


resource "aws_subnet" "webapps" {

  vpc_id            = aws_vpc.production.id
  cidr_block        = var.subnet_cidr
  availability_zone = var.subnet_az

  tags = {
    Name = "Web Applications Subnet"
  }

}