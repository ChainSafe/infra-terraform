locals {
  zone_name = var.zone_domain != "" ? var.zone_domain : join(".",
    compact([
      replace(var.default_variables.account_name, "-prod", ""),
      "aws",
      var.default_variables.global_hosted_zone
    ])
  )
  zone_name_short = replace(local.zone_name, ".${var.default_variables.global_hosted_zone}", "")
}

resource "aws_route53_zone" "this" {
  count = var.enable_public_zone ? 1 : 0

  name = local.zone_name

  tags = merge(
    var.tags,
    {
      Name = local.zone_name
      Tier = "public"
    }
  )
}

# resource "aws_route53_zone" "private" {
#   name = local.zone_name
#
#
#   vpc {
#     vpc_id = data.aws_vpc.this.id
#   }
#
#   tags = merge(
#     var.tags,
#     {
#       Name = local.zone_name
#       Tier = "private"
#     }
#   )
#
#   lifecycle {
#     ignore_changes = [
#       vpc
#     ]
#   }
# }

resource "cloudflare_dns_record" "this" {
  for_each = toset(aws_route53_zone.this[0].name_servers)

  zone_id = data.cloudflare_zone.this.zone_id

  type    = "NS"
  name    = local.zone_name_short
  content = each.value
  comment = "Domain federation record"
  proxied = false
  ttl     = 300
}
