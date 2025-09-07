# resource "cloudflare_dns_record" "dns_record" {
#   for_each = var.servers
#
#   zone_id = data.cloudflare_zone.this.zone_id
#
#   # Will result in for example: "node-2.api.dev" # node-0.v2.cdn.devnet (.example.network)
#   name = join(".",
#     compact([
#       # Name prefix, e.g. "node-2"
#       each.value,
#       var.subdomain
#     ])
#   )
#
#   content = data.ovh_dedicated_server.this[each.key].ip
#   type    = "A"
#   ttl     = 3600
# }
