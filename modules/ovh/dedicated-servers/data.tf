data "ovh_me" "this" {}

data "cloudflare_zone" "this" {
  count = var.domain_name != null ? 1 : 0
  filter = {
    name = var.domain_name
  }
}

data "ovh_dedicated_installation_template" "this" {
  template_name = var.configuration.os
}
