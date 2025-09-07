resource "cloudflare_dns_record" "dns_record" {
  for_each = local.node_ids

  zone_id = data.cloudflare_zone.this.zone_id

  # Will result in for example: "node-2.api.dev" # node-0.v2.cdn.devnet (.example.network)
  name = join(".",
    compact([
      # Name prefix, e.g. "node-2"
      local.resource_name,
      var.subdomain
    ])
  )

  content = hcloud_server.this[each.key].ipv4_address
  type    = "A"
  ttl     = 3600
}
