provider "aws" {
  profile    = "terraform"
  region     = var.aws_region
}

resource "aws_key_pair" "auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "module_example" {
  ami           = var.aws_ami
  instance_type = var.aws_instance_type
  subnet_id     = module.vpc.public_subnets[0]
  key_name      = aws_key_pair.auth.id
  associate_public_ip_address = true
  vpc_security_group_ids = [module.web_sg.this_security_group_id, module.home_sg.this_security_group_id]

  tags = {
    Name = "module_example"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.module_example.private_ip} >> private_ips.txt"
  }
}

resource "aws_eip" "module_example" {
  vpc = true
  instance = aws_instance.module_example.id
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "module_example"
  cidr = var.vpc_cidr

  azs             = [var.aws_availability_zone]
  private_subnets = [var.private_subnet_cidr]
  public_subnets  = [var.public_subnet_cidr]

  enable_dns_hostnames = true
  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "web_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "module_example_web_sg"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks      = [var.full_cidr]
  ingress_rules            = ["http-80-tcp", "https-443-tcp"]
  egress_rules             = ["all-all"]
}

module "home_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "module_example_home_sg"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks      = [var.my_cidr]
  ingress_rules            = ["ssh-tcp", "all-icmp"]
  egress_rules             = ["all-all"]
}
