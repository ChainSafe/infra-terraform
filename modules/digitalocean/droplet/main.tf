resource "digitalocean_droplet" "this" {
  name   = local.resource_name
  image  = var.image
  region = var.region
  size   = var.size

  backups    = var.backups
  monitoring = true
  ipv6       = true

  ssh_keys = var.ssh_keys
  tags     = var.droplet_tags

  lifecycle {
    # ssh_keys only apply at creation and changing them replaces the droplet; Ansible manages keys after boot.
    ignore_changes = [
      ssh_keys
    ]
  }
}

resource "digitalocean_reserved_ip" "this" {
  region = var.region
}

resource "digitalocean_reserved_ip_assignment" "this" {
  ip_address = digitalocean_reserved_ip.this.ip_address
  droplet_id = digitalocean_droplet.this.id
}
