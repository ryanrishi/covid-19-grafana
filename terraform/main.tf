provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

terraform {
  backend "s3" {
    bucket = "ryanrishi-terraform-test"
    key    = "covid-19-grafana/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.aws_vpc_cidr
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = lookup(var.aws_subnet_cidr_block, terraform.workspace)
}

resource "aws_security_group" "security_group" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outgoing traffic to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.aws_key_name
  public_key = var.aws_public_key
}


resource "aws_instance" "web" {
  instance_type = var.aws_instance_type
  ami           = lookup(var.aws_amis, var.aws_region)

  key_name = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [
    aws_security_group.security_group.id
  ]

  subnet_id = aws_subnet.subnet.id

  user_data = templatefile("./templates/init.sh.tmpl", {
    grafana_admin_user     = var.grafana_admin_user
    grafana_admin_password = var.grafana_admin_password
    grafana_server_domain  = var.grafana_server_domain
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "elastic_ip" {
  instance = aws_instance.web.id
  vpc      = true
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}

output "public_dns" {
  value = aws_eip.elastic_ip.public_dns
}
