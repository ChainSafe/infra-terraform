locals {
  vpc_name = "main"
}

data "aws_vpc" "this" {
  tags = {
    Name = local.vpc_name
  }
}

data "cloudflare_zone" "this" {
  filter = {
    name = var.cloudflare.zone_name
  }
}

data "cloudflare_account" "this" {
  filter = {
    name = var.cloudflare.account_name
  }
}
