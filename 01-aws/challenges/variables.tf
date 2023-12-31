variable "aws_region" {
  description = "The aws region where operations will take place"
  type        = string
}

variable "vpc_cidr" {
  description = "Cidr block for vpc"
  type        = string
}

variable "subnet_cidr" {
  description = "Cidr Block for Subnet"
  type        = string
}

variable "subnet_az" {
  description = "Availability Zone for Subnet"
  type        = string
}