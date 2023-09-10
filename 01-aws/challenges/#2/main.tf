resource "aws_vpc" "production" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "Production VPC"
  }
}