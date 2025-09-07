output "domains" {
  value = [
    for record in cloudflare_dns_record.dns_record :
    "${record.name}.${var.domain_name}"
  ]
  description = "List of created domains"
}

output "servers" {
  value = [
    for servers in hcloud_server.this :
    servers.name
  ]
  description = "List of created servers"
}
