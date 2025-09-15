variable "secrets" {
  type = object({
    ovh_endpoint     = optional(string, "ovh-ca")
    ovh_app_key      = string
    ovh_app_secret   = string
    ovh_consumer_key = string
  })
  description = <<DESC
Authentication to CloudFlare, OVHCloud

Example:
secrets = {
  ovh_endpoint = "ovh-ca"
  ovh_app_key = "SecretKey"
  ovh_app_secret = "SecretSecret"
  ovh_consumer_key = "SecretConsumerKey"
}
DESC
  sensitive   = true
}

variable "dedicated_servers" {
  type = set(string)

  description = <<DESC
List of dedicated servers to attach to vRack (defaults [])

Example:
* dedicated_servers = [
  "nsxxxxxx.ip-xx-xx-xx.eu"
]
DESC

  default = []
}
