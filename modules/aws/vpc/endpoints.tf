module "endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.14.0"

  vpc_id = module.vpc.vpc_id
  security_group_ids = [
    module.vpc.default_security_group_id
  ]

  create_security_group      = true
  security_group_name_prefix = "${local.vpc_name}-vpc-endpoints-"
  security_group_rules = {
    ingress_https = {
      description = "HTTPS from VPC"
      cidr_blocks = [module.vpc.vpc_cidr_block]
    }
  }
  endpoints = {
    for k, v in var.endpoint_services :
    k => {
      service      = v.service_name == "" ? k : null
      service_name = v.service_name != "" ? v.service_name : null
      service_type = v.service_type

      private_dns_enabled = v.private_dns

      route_table_ids = v.subnet_types == "Gateway" ? flatten([
        module.vpc.private_route_table_ids,
        module.vpc.public_route_table_ids,
      ]) : null

      subnet_ids = v.service_type != "Gateway" ? compact(
        flatten([
          contains(v.subnet_types, "private") ? (v.multi_az ? module.vpc.private_subnets : [module.vpc.private_subnets[0]]) : [],
          contains(v.subnet_types, "public") ? (v.multi_az ? module.vpc.public_subnets : [module.vpc.public_subnets[0]]) : []
        ])
      ) : null

      tags = merge(
        local.global_tags,
        var.tags,
        {
          Name = "${local.vpc_name}-endpoint-${k}"
        }
      )
    }
  }
}
