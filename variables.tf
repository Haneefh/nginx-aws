variable "aws_region" {
  default = "us-east-1"
}


variable "vpc_cidr" {
  description = "Enter a cidr block in /16 subnet"
  default     = "10.0.0.0/16"
}

variable "name" {
  description = "Name of the resource"
}

variable "instance_tenancy" {
  default = "default"
}

variable "dns_hostnames" {
  default = true
}

variable "instance_type" {
  description = "Ec2 instance type"
  default     = "t2.small"
}

variable "key_name" {}
variable "public_key_path" {}
variable "private_key_path" {}

variable "ssh_user" {
  default = "ubuntu"
}
