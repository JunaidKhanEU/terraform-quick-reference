# Terraform Settings Block
terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0" # Optional but recommended in production
    }
  }
}

# Provider Block
provider "aws" {
  region = var.aws_region
}



# security group vpc_ssh

resource "aws_security_group" "vpc_ssh_sg" {
  name        = "vpc_ssh_sg"
  description = "dev vpc ssh"

  ingress {
    description = "allow port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "allow all IP and port outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc_ssh_sg"
  }
}


# security group vpc_web
resource "aws_security_group" "vpc_web_sg" {
  name        = "vpc_web_sg"
  description = "dev vpc web"

  ingress {
    description = "allow port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "allow all IP and port outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc_web_sg"
  }
}

# data source ami

data "aws_ami" "amz_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-*-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# AZs
data "aws_availability_zones" "azs" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# Resource Block Instance
resource "aws_instance" "ec2demo" {
  ami               = data.aws_ami.amz_linux2.id # Amazon Linux in us-east-1, update as per your region
  instance_type     = var.instance_type["dev"]
  user_data         = file("${path.module}/app1-install.sh")
  for_each          = toset(data.aws_availability_zones.azs.names)
  availability_zone = each.key

  vpc_security_group_ids = [aws_security_group.vpc_ssh_sg.id, aws_security_group.vpc_web_sg.id]
  tags = {
    "Name" = "demos - ${each.value}"
  }


}
