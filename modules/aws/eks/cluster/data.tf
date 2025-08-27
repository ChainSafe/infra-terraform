locals {
  vpc_name = var.subnet_types.vpc_name != "" ? var.subnet_types.vpc_name : "main"
}

data "aws_caller_identity" "current" {}
data "aws_organizations_organization" "this" {}
data "aws_partition" "current" {}

data "aws_vpc" "this" {
  tags = {
    Name = local.vpc_name
  }
}

data "aws_subnets" "nodes" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  tags = {
    Tier = var.subnet_types.nodes
  }
}

data "aws_subnets" "control_plane" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  tags = {
    Tier = var.subnet_types.control_plane
  }
}

data "aws_subnet" "control_plane" {
  for_each = toset(data.aws_subnets.control_plane.ids)
  id       = each.value
}

locals {
  control_plane_subnet_ids = [
    for subnet in data.aws_subnet.control_plane :
    subnet.id
    if contains(formatlist("${var.default_variables.region}%s", var.subnet_types.availability_zones), subnet.availability_zone)
  ]
}

data "aws_security_group" "web_access" {
  vpc_id = data.aws_vpc.this.id
  tags = {
    type = "web-access"
  }
}

data "aws_iam_roles" "administrators" {
  name_regex  = "AWSReservedSSO_AWSAdministratorAccess_.*"
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
}
