locals {
  vpc_name = "main"

  vpc_subnets = zipmap(
    ["private", "public", "internal", "database"],
    cidrsubnets(var.cidr.vpc, 1, 4, 4, 4)
  )
  public_subnets = length(var.cidr.public_subnets) == 0 ? [
    for idx, az in var.availability_zones :
    cidrsubnet(local.vpc_subnets["public"], 2, idx)
  ] : var.cidr.public_subnets
  private_subnets = length(var.cidr.private_subnets) == 0 ? [
    for idx, az in var.availability_zones :
    cidrsubnet(local.vpc_subnets["private"], 2, idx)
  ] : var.cidr.private_subnets

  internal_subnets = var.create_internal_subnets ? (
    length(var.cidr.internal_subnets) == 0 ? [
      for idx, az in var.availability_zones :
      cidrsubnet(local.vpc_subnets["internal"], 2, idx)
    ] : var.cidr.internal_subnets
  ) : []

  database_subnets = var.create_database_subnets ? (
    length(var.cidr.database_subnets) == 0 ? [
      for idx, az in var.availability_zones :
      cidrsubnet(local.vpc_subnets["database"], 2, idx)
    ] : var.cidr.database_subnets
  ) : []

  company_networks = distinct(
    flatten(
      [
        var.company_networks,
        values(var.vgw.networks)
      ]
    )
  )

  tgw_routes = {
    for route in setproduct(var.attach_tgws, toset(module.vpc.private_route_table_ids)) :
    "${route[0]}-${route[1]}" => {
      tgw            = route[0]
      route_table_id = route[1]
    }
  }
}
