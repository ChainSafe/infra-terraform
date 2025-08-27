/**
 * # AWS VPC module
 *
 * Create vpc and subnets.
 *
 */

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  name = local.vpc_name
  cidr = var.cidr.vpc

  secondary_cidr_blocks = var.cidr.secondary_cidr_blocks

  azs = [
    for az in var.availability_zones :
    "${var.default_variables.region}${az}"
  ]
  public_subnets   = local.public_subnets
  private_subnets  = local.private_subnets
  intra_subnets    = local.internal_subnets
  database_subnets = local.database_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true
  reuse_nat_ips          = true
  external_nat_ip_ids = [
    for k, v in aws_eip.nat :
    v.id
  ]

  create_database_subnet_group  = true
  manage_default_security_group = var.manage_default_security_group

  enable_vpn_gateway = var.vgw.asn != 0
  amazon_side_asn    = var.vgw.asn != 0 ? var.vgw.asn : null

  propagate_public_route_tables_vgw  = true
  propagate_private_route_tables_vgw = true
  propagate_intra_route_tables_vgw   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
    Tier                     = "public"
  }
  public_subnet_tags_per_az = {
    for az in var.availability_zones :
    "${var.default_variables.region}${az}" => {
      Name = "${local.vpc_name}-public-1${az}"
    }
  }

  private_subnet_tags = {
    Tier                              = "private"
    "kubernetes.io/role/internal-elb" = 1
  }
  private_subnet_tags_per_az = {
    for az in var.availability_zones :
    "${var.default_variables.region}${az}" => {
      Name = "${local.vpc_name}-private-1${az}"
    }
  }

  intra_subnet_tags = {
    Tier = "internal"
  }
  database_subnet_tags = {
    Tier = "db"
  }
  public_route_table_tags = {
    Tier = "public"
  }
  private_route_table_tags = {
    Tier = "private"
  }
  intra_route_table_tags = {
    Tier = "internal"
  }
  tags = merge(
    local.global_tags,
    var.tags
  )
}
