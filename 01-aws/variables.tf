variable "aws_region" {
  type = string
  default = "eu-west-3"
  
}

variable "vpc_cidr" {
  description = "Cidr block for vpc"
  default     = "192.168.1.0/24"
  type        = string
}

variable "private_subnet_cidr" {
  description = "Cidr block for private subnet"
  default     = "192.168.1.0/25"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Cidr block for public subnet"
  default     = "192.168.1.128/25"
  type        = string
}

variable "ip_address_list" {
  description = "A list that contains ip addresses"
  type        = list(string)
  default     = ["196.203.181.122/32"]
}

variable "instance_type" {
  description = "The type of ec2 instance"
  type        = string
  default     = "t2.micro"

}


variable "rsa_public_key" {

  description = "Rsa public key for ssh"
  type        = string

}