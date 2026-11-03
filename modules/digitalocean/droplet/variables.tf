variable "secrets" {
  type = object({
    do_token = string
  })
  description = <<DESC
Authentication to DigitalOcean

Example:
secrets = {
  do_token = "SecretSecret"
}
DESC
  sensitive   = true
}

variable "region" {
  type = string

  description = <<DESC
The DigitalOcean region slug

Example:
* region = "tor1"
DESC
}

variable "image" {
  type = string

  description = <<DESC
The image slug or ID (defaults "ubuntu-24-04-x64")

Example:
* image = "ubuntu-24-04-x64"
DESC

  default = "ubuntu-24-04-x64"
}

variable "size" {
  type = string

  description = <<DESC
The droplet size slug (defaults "s-1vcpu-2gb")

More details: https://slugs.do-api.dev/

Example:
* size = "s-2vcpu-4gb"
DESC

  default = "s-1vcpu-2gb"
}

variable "backups" {
  type = bool

  description = <<DESC
Enable DigitalOcean droplet backups (defaults true)

Example:
* backups = true
DESC

  default = true
}

variable "ssh_keys" {
  type = list(string)

  description = <<DESC
The list of SSH key IDs or fingerprints already in the DigitalOcean account (at least one)

Example:
* ssh_keys = [
  "12:34:45:65:df:ds:3f:2s:14:sx:qw:er:ty:yu:ui:fg"
]
DESC

  validation {
    condition     = length(var.ssh_keys) > 0
    error_message = "At least one SSH key is required, otherwise DigitalOcean sets a root password."
  }
}

variable "ssh_allowlist" {
  type = list(string)

  description = <<DESC
Source CIDRs allowed to reach SSH on port 22 (defaults [], SSH closed)

Example:
* ssh_allowlist = [
  "203.0.113.10/32"
]
DESC

  default = []
}

variable "droplet_tags" {
  type = set(string)

  description = <<DESC
DigitalOcean tags attached to the droplet (defaults [])

Example:
* droplet_tags = [
  "blog",
  "ghost"
]
DESC

  default = []
}
