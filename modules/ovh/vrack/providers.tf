provider "ovh" {
  endpoint = var.secrets.ovh_endpoint

  application_key    = var.secrets.ovh_app_key
  application_secret = var.secrets.ovh_app_secret
  consumer_key       = var.secrets.ovh_consumer_key
}
