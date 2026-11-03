terraform {
  required_version = ">= 1.10"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.106"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.6"
    }
  }
}
