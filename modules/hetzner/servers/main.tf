resource "hcloud_server" "this" {
  for_each = local.node_ids

  name = local.resource_name

  image       = var.image
  server_type = var.node_type
  datacenter  = local.hc_regions[tonumber(each.key) % length(local.hc_regions)]
  keep_disk   = true

  labels = local.labels

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  ssh_keys = var.ssh_keys

  lifecycle {
    ignore_changes = [
      datacenter,
      ssh_keys
    ]
  }
}
