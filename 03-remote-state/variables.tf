variable "aws_region" {
  description = "Aws Region"
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
