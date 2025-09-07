data "cloudflare_zone" "this" {
  filter = {
    name = var.zome_name
  }
}

data "cloudflare_account" "this" {
  filter = {
    name = var.default_variables.account_name
  }
}
