terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

resource "aws_key_pair" "younes_keypair" {
  key_name   = "younes_keypair"
  public_key = file("C:\\Users\\AYMAN PCW11\\.ssh\\terraform-ipssi.pub")
}

resource "aws_security_group" "younes_sg" {
  name        = "younes_sg"
  description = "Allow SSH and HTTP"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "younes_sg_allow_ssh" {
  security_group_id = aws_security_group.younes_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "younes_sg_allow_http" {
  security_group_id = aws_security_group.younes_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "younes_sg_allow_all" {
  security_group_id = aws_security_group.younes_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "younes_serverweb" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.my_instance_type
  subnet_id                   = "subnet-0a38a0323b4ac7794"
  key_name                    = aws_key_pair.younes_keypair.key_name
  associate_public_ip_address = true
  security_groups             = [aws_security_group.younes_sg.id]

  tags = {
    Name = "Younes-MV"
  }
}