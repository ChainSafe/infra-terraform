resource "hcloud_firewall" "this" {
  name = local.resource_name

  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  dynamic "rule" {
    for_each = var.access
    iterator = i

    content {
      port       = i.key
      source_ips = i.value
      direction  = "in"
      protocol   = "tcp"
    }
  }
}

resource "hcloud_firewall_attachment" "this" {
  firewall_id = hcloud_firewall.this.id
  server_ids = [
    for servers in hcloud_server.this :
    servers.id
  ]
}
