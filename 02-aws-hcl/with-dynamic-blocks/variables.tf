variable "aws_region" {
  description = "The Aws Region"
  type        = string
  default     = "eu-west-3"

}

variable "vpc_cidr" {
  description = "Cidr Block for Vpc"
  default     = "192.168.1.0/24"
  type        = string
}

variable "enable_dns" {
  description = "Dns Support for the Vpc"
  type        = bool
  default     = true

}

variable "availability_zones" {
  description = "Availability Zones in the Region"
  type        = list(string)
}

variable "subnets_cidr_blocks" {
  description = "Cidr Blocks for Subnets"
  type        = list(string)
  default     = ["192.168.1.0/26", "192.168.1.64/26", "192.168.1.128/26"]
}

variable "ssh_public_key" {
  description = "Public Key to SSH into Ec2"
  type        = string

}


variable "instance_type" {

  description = "Ec2 Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "apache_user_data" {
  description = "Ec2 Apache server user data"
  type        = string
}


variable "allowed_ports" {
  description = "List of Allowed ports"
  type        = list(number)
  default     = [80, 443]

}
