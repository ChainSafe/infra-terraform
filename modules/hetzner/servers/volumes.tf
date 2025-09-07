resource "hcloud_volume" "this" {
  for_each = var.volume_size > 0 ? local.node_ids : []

  name = local.resource_name

  size     = var.volume_size
  location = hcloud_server.this[each.key].location
  format   = "ext4"
}

resource "hcloud_volume_attachment" "this" {
  for_each = var.volume_size > 0 ? local.node_ids : []

  volume_id = hcloud_volume.this[each.key].id
  server_id = hcloud_server.this[each.key].id
  automount = true
}
