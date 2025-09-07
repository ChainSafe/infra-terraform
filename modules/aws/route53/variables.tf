variable "secrets" {
  type = object({
    cf_api_token = string
  })
  description = <<DESC
Authentication to CloudFlare

Example:
secrets = {
  cf_api_token = "SecretSecret"
}
DESC
  sensitive   = true
}

variable "zone_domain" {
  type        = string
  description = <<DESC
Domain for the account hosted zones

Example:
* zone_domain = "finance"
DESC

  default = ""
}

variable "enable_public_zone" {
  type        = bool
  description = <<DESC
If public zone is created (defaults true)

Example:
* enable_public_zone = false
DESC
  default     = true
}

variable "cloudflare" {
  type = object({
    zone_name    = string
    account_name = string
  })

  description = <<DESC
Configuration of CloudFlare federation

Example:
* cloudflare = {
  zone_name = "example"
  account_name = "example"
}
DESC

  default = {
    zone_name    = ""
    account_name = ""
  }
}
