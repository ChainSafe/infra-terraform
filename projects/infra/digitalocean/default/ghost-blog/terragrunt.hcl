# ---------------------------------------------------------------------------------------------------------------------
# You can find latest template for this module at:
# https://github.com/ChainSafe/infra-terraform/tree/main/modules/digitalocean/droplet/examples/
# ---------------------------------------------------------------------------------------------------------------------

locals {
  stack_name    = "modules/digitalocean/droplet"
  stack_version = "main" # FIXME: Please update version if required

  stack_host       = "git::git@github.com"
  stack_repository = "ChainSafe/infra-terraform"
}

# Terragrunt will copy the Terraform configurations specified by the source
# parameter, along with any files in the working directory,
# into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${local.stack_host}:${local.stack_repository}.git//${local.stack_name}?ref=${local.stack_version}"
}

include "root" {
  path = find_in_parent_folders("terragrunt-core.hcl")
}


# TODO: These are the variables we have to pass in to use the module specified in the terragrunt configuration above:
inputs = merge(
  try(
    yamldecode(
      sops_decrypt_file("secrets.tfvars.yaml")
    ),
    yamldecode(
      file("secrets.tfvars.yaml")
    )
  ),
  {
    # ---------------------------------------------------------------------------------------------------------------------
    # Components of the name
    #
    # * purpose: Purpose of the resource. E.g. "upload-images"
    # * separator: Name separator (defaults "-")
    #
    # Resource name will be <project>-<env>-<purpose>-(|<type of resource>)
    #
    # Example:
    # * name = {
    #   purpose = "upload-images"
    #   separator = "_"
    # }
    # ---------------------------------------------------------------------------------------------------------------------
    name = {
      purpose = "blog"
    }

    # ---------------------------------------------------------------------------------------------------------------------
    # The DigitalOcean region slug
    #
    # Example:
    # * region = "tor1"
    # ---------------------------------------------------------------------------------------------------------------------
    region = "tor1"

    # ---------------------------------------------------------------------------------------------------------------------
    # The droplet size slug (defaults "s-1vcpu-2gb")
    #
    # More details: https://slugs.do-api.dev/
    #
    # Example:
    # * size = "s-2vcpu-4gb"
    # ---------------------------------------------------------------------------------------------------------------------
    size = "s-2vcpu-4gb"

    # ---------------------------------------------------------------------------------------------------------------------
    # The list of SSH key IDs or fingerprints already in the DigitalOcean account (defaults [])
    #
    # Example:
    # * ssh_keys = [
    #   "12:34:45:65:df:ds:3f:2s:14:sx:qw:er:ty:yu:ui:fg"
    # ]
    # ---------------------------------------------------------------------------------------------------------------------
    # FIXME: add the fingerprint of the new deploy key before the first apply
    ssh_keys = []

    # ---------------------------------------------------------------------------------------------------------------------
    # Source CIDRs allowed to reach SSH on port 22 (defaults [], SSH closed)
    #
    # Example:
    # * ssh_allowlist = [
    #   "203.0.113.10/32"
    # ]
    # ---------------------------------------------------------------------------------------------------------------------
    ssh_allowlist = []

    # ---------------------------------------------------------------------------------------------------------------------
    # DigitalOcean tags attached to the droplet (defaults [])
    #
    # Example:
    # * droplet_tags = [
    #   "blog",
    #   "ghost"
    # ]
    # ---------------------------------------------------------------------------------------------------------------------
    droplet_tags = [
      "blog",
      "ghost",
    ]
  }
)
