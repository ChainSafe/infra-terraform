variable "secrets" {
  type = object({
    ovh_endpoint     = optional(string, "ovh-ca")
    ovh_app_key      = string
    ovh_app_secret   = string
    ovh_consumer_key = string
    # cf_api_token     = string
  })
  description = <<DESC
Authentication to CloudFlare, OVHCloud

Example:
secrets = {
  ovh_endpoint = "ovh-ca"
  ovh_app_key = "SecretKey"
  ovh_app_secret = "SecretSecret"
  ovh_consumer_key = "SecretConsumerKey"

  cf_api_token = "SecretSecret"
}
DESC
  sensitive   = true
}

variable "servers" {
  type = map(string)

  description = <<DESC
Dedicate Server IDs and names for configuration (defaults {})


Example:
* servers = {
  "nsxxxxxxx.ip-xx-xx-xx.eu" = "api-foo-back"
}
DESC

  default = {}
}

variable "configuration" {
  type = object({
    os      = optional(string, "ubuntu2404-server_64")
    ssh_key = optional(string, "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQdyDPqu80ZSimqReNHZhHN7xTSK4CXTHjI2nZlQ911 awx@chainsafe.io")
    script = optional(string,
      <<-SCRIPT
      #!/bin/bash
      apt update
      apt install -y ansible git wget

      git clone "https://github.com/next-gen-infrastructure/ansible-public" /tmp/bootstrap
      ansible-playbook -i localhost, -c local /tmp/bootstrap/bootstrap.yml
      SCRIPT
    )
    monitoring   = optional(bool, true)
    intervention = optional(bool, true)
  })

  description = <<DESC
Configuration of Servers

Available options:
* os - https://ca.api.ovh.com/v1/dedicated/installationTemplate
* ssh - AWX public key
* script - Post installation script

Example:
* configuration = {
  os = "ubuntu2404-server_64"

  script = <<-SCRIPT
  #!/bin/bash
  hostnamectl set-hostname $${hostname}
  SCRIPT
}
DESC

  default = {
    os           = "ubuntu2404-server_64"
    ssh_key      = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQdyDPqu80ZSimqReNHZhHN7xTSK4CXTHjI2nZlQ911 awx@chainsafe.io"
    script       = <<-SCRIPT
    #!/bin/bash
    apt update
    apt install -y ansible git wget

    git clone "https://github.com/next-gen-infrastructure/ansible-public.git" /tmp/bootstrap
    # ansible-playbook -i localhost, -c local /tmp/bootstrap/bootstrap.yml --check
    SCRIPT
    monitoring   = true
    intervention = true
  }
}

variable "domain_name" {
  type = string

  description = <<DESC
The name of the zone (defaults null)

Example:
* domain_name = "example.org"
DESC
  default     = null
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
