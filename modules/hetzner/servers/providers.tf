provider "cloudflare" {
  api_token = var.secrets.cf_api_token
}

provider "hcloud" {
  token = var.secrets.hcloud_token
}
