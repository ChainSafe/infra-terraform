output "droplet_id" {
  value       = digitalocean_droplet.this.id
  description = "ID of the droplet"
}

output "reserved_ip" {
  value       = digitalocean_reserved_ip.this.ip_address
  description = "Reserved IP assigned to the droplet"
}
