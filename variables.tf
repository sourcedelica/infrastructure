variable "public_key_path" {
  description = "Path to the SSH public key to be used for authentication"
  default = "/Users/eric/.ssh/terraform.pub"
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  default = "terraform"
}

variable "my_cidr" {
  default = "74.66.1.193/32"
}

variable "aws_ami" {
  description = "AWS image"
  default     = "ami-0ab1d87ce9286b9a4"
}

variable "aws_instance_type" {
  description = "AWS instance type"
  default     = "t2.micro"
}

variable "aws_region" {
  description = "AWS region to launch servers"
  default     = "us-east-1"
}

variable "aws_availability_zone" {
  description = "AWS availability zone"
  default     = "us-east-1a"
}

variable "full_cidr" {
  description = "Full CIDR block"
  default     = "0.0.0.0/0"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the Public Subnet"
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the Public Subnet"
  default = "10.0.2.0/24"
}

output "ip" {
  value = aws_eip.module_example.public_ip
}
