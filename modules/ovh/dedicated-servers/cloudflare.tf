resource "cloudflare_dns_record" "dns_record" {
  for_each = var.domain_name != null ? var.servers : {}

  zone_id = data.cloudflare_zone.this[0].zone_id

  name = join(".",
    compact([
      substr(
        join(
          var.name.separator,
          compact(
            [
              local.resource_name,
              each.value
            ]
          )
      ), 0, 40),
      var.subdomain,
      "ovh",
    ])
  )

  content = ovh_dedicated_server.this[each.key].ip
  type    = "A"
  ttl     = 3600
}

#
#
# resource "cloudflare_dns_record" "dns_record" {
#   for_each = var.servers
#
#   zone_id = data.cloudflare_zone.this.zone_id
#
#   # Will result in for example: "node-2.api.dev" # node-0.v2.cdn.devnet (.example.network)
#   name = join(".",
#     compact([
#       # Name prefix, e.g. "node-2"
#       substr(each.value, 0, 40),
#       "ovh",
#       var.subdomain
#     ])
#   )
#
#   content = ovh_dedicated_server.this[each.key].ip # FIXME
#   type    = "AAAA"
#   ttl     = 3600
# }
