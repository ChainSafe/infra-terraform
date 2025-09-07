data "hcloud_datacenters" "this" {}

data "cloudflare_zone" "this" {
  filter = {
    name = var.domain_name
  }
}
