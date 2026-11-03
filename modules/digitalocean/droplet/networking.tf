resource "digitalocean_firewall" "this" {
  name = local.resource_name

  droplet_ids = [
    digitalocean_droplet.this.id
  ]

  dynamic "inbound_rule" {
    for_each = toset(["80", "443"])

    content {
      protocol         = "tcp"
      port_range       = inbound_rule.value
      source_addresses = local.cloudflare_ips
    }
  }

  dynamic "inbound_rule" {
    for_each = length(var.ssh_allowlist) > 0 ? [1] : []

    content {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = var.ssh_allowlist
    }
  }

  #trivy:ignore:AVD-DIG-0003 all outbound allowed by design
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  #trivy:ignore:AVD-DIG-0003 all outbound allowed by design
  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  #trivy:ignore:AVD-DIG-0003 all outbound allowed by design
  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
