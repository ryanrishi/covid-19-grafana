variable "aws_region" {
  default = "us-east-1"
}

variable "aws_profile" {
  default = "ryanrishi"
}

variable "aws_amis" {
  default = {
    us-east-1 = "ami-0aee8ced190c05726"
  }
}

variable "aws_instance_type" {
  default = "t3.small"
}

variable "aws_key_name" {
  default = "ryan"
}

variable "aws_public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0Ru52tplYR3TrDVkLprihVnRApZDYpSbSTjQGn7AWYgJm+... me@example.com"
}

variable "grafana_admin_user" {}

variable "grafana_admin_password" {}

variable "grafana_server_domain" {}
