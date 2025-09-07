variable "secrets" {
  type = object({
    hcloud_token = string
    cf_api_token = string
  })
  description = <<DESC
Authentication to CloudFlare, HCloud

Example:
secrets = {
  hcloud_token = "SecretSecret"
  cf_api_token = "SecretSecret"
}
DESC
  sensitive   = true
}

variable "access" {
  type = map(
    set(string)
  )

  description = <<DESC
Configuration of network access to servers (defaults {})

Key is a port, value is list of source addresses

Example:
* access = {
    "80" = [
        "10.0.0.0/8",
        "192.168.0.0/16"
    ]

    "443" = [
        "192.168.0.0/16"
    ]
}
DESC

  default = {}
}

variable "domain_name" {
  type = string

  description = <<DESC
The name of the CloudFlare zone

Example:
* domain_name = "example.org"
DESC
}

variable "instance_count" {
  type = number

  description = <<DESC
The number of servers (defaults 0)

Example:
* instance_count = 2
DESC

  default = 0
}

variable "instance_ids" {
  type = set(string)

  description = <<DESC
Alternative to server count ids (defaults [])

If provided will create servers based on provided list of values.

Example:
* instance_ids = [
  "first",
  "second",
  "3"
]
DESC

  default = []
}

variable "subdomain" {
  type = string

  description = <<DESC
The subdomain of application (defaults "")

Example:
* subdomain = "api"
DESC

  default = ""
}


variable "image" {
  type = string

  description = <<DESC
The image ID or name (defaults "ubuntu-22.04")

Example:
* image = "ubuntu-22.04"
DESC

  default = "ubuntu-24.04"
}

variable "node_type" {
  type = string

  description = <<DESC
The unique slug that identifies the type of Server (defaults "cax11")

Available options:
* "cpx[1-5]1" Shared AMD64
* "cax[1-4]1" Shared ARM64
* "ccx[1-6]3" Dedicated AMD64
* "cx[2-5]2" Shared x86_64
More details: https://www.vpsbenchmarks.com/instance_types/hetzner

Example:
* node_type = "cpx11"
DESC

  default = "cax11"
}

variable "ssh_keys" {
  type = list(string)

  description = <<DESC
The list of ssh keys for server access (defaults [])

Example:
* ssh_keys = [
  "12:34:45:65:df:ds:3f:2s:14:sx:qw:er:ty:yu:ui:fg"
]
DESC

  default = []
}

variable "volume_size" {
  type = number

  description = <<DESC
The size of the volume that will be attached to servers (defaults 0)

Example:
* volume_size = 64
DESC

  default = 0
}
