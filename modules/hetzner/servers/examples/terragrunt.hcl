# ---------------------------------------------------------------------------------------------------------------------
# You can find latest template for this module at:
# https://github.com/ChainSafe/infra-terraform/tree/main/modules/hetzner/servers/examples/
# ---------------------------------------------------------------------------------------------------------------------

locals {
  stack_name    = "modules/hetzner/servers"
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
    Resource name will be <project>-<env>-<purpose>-(|<type of resource>)
    #
    # Example:
    # * name = {
    #   purpose = "upload-images"
    #   separator = "_"
    # }
    # ---------------------------------------------------------------------------------------------------------------------
    # name = {
    #   purpose = ""
    #   separator = "-"
    # }

    # ---------------------------------------------------------------------------------------------------------------------
    # Map of the custom resource tags (defaults {})
    #
    # Example:
    # * tags = {
    #   Foo = "Bar"
    # }
    # ---------------------------------------------------------------------------------------------------------------------
    # tags = {}

    # ---------------------------------------------------------------------------------------------------------------------
    # The image ID or name (defaults "ubuntu-22.04")
    #
    # Example:
    # * image = "ubuntu-22.04"
    # ---------------------------------------------------------------------------------------------------------------------
    # image = "ubuntu-24.04"

    # ---------------------------------------------------------------------------------------------------------------------
    # The unique slug that identifies the type of Server (defaults "cax11")
    #
    # Available options:
    # * "cpx[1-5]1" Shared AMD64
    # * "cax[1-4]1" Shared ARM64
    # * "ccx[1-6]3" Dedicated AMD64
    # * "cx[2-5]2" Shared x86_64
    # More details: https://www.vpsbenchmarks.com/instance_types/hetzner
    #
    # Example:
    # * node_type = "cpx11"
    # ---------------------------------------------------------------------------------------------------------------------
    # node_type = "cax11"

    # ---------------------------------------------------------------------------------------------------------------------
    # The list of ssh keys for server access (defaults [])
    #
    # Example:
    # * ssh_keys = [
    #   "12:34:45:65:df:ds:3f:2s:14:sx:qw:er:ty:yu:ui:fg"
    # ]
    # ---------------------------------------------------------------------------------------------------------------------
    # ssh_keys = []

    # ---------------------------------------------------------------------------------------------------------------------
    # The size of the volume that will be attached to servers (defaults 0)
    #
    # Example:
    # * volume_size = 64
    # ---------------------------------------------------------------------------------------------------------------------
    # volume_size = 0

    # ---------------------------------------------------------------------------------------------------------------------
    # Configuration of network access to servers (defaults {})
    #
    # Key is a port, value is list of source addresses
    #
    # Example:
    # * access = {
    #     "80" = [
    #         "10.0.0.0/8",
    #         "192.168.0.0/16"
    #     ]
    #
    #     "443" = [
    #         "192.168.0.0/16"
    #     ]
    # }
    # ---------------------------------------------------------------------------------------------------------------------
    # access = {}

    # ---------------------------------------------------------------------------------------------------------------------
    # The name of the CloudFlare zone
    #
    # Example:
    # * domain_name = "example.org"
    # ---------------------------------------------------------------------------------------------------------------------
    domain_name =

    # ---------------------------------------------------------------------------------------------------------------------
    # The number of servers (defaults 0)
    #
    # Example:
    # * instance_count = 2
    # ---------------------------------------------------------------------------------------------------------------------
    # instance_count = 0

    # ---------------------------------------------------------------------------------------------------------------------
    # Alternative to server count ids (defaults [])
    #
    # If provided will create servers based on provided list of values.
    #
    # Example:
    # * instance_ids = [
    #   "first",
    #   "second",
    #   "3"
    # ]
    # ---------------------------------------------------------------------------------------------------------------------
    # instance_ids = []

    # ---------------------------------------------------------------------------------------------------------------------
    # The subdomain of application (defaults "")
    #
    # Example:
    # * subdomain = "api"
    # ---------------------------------------------------------------------------------------------------------------------
    # subdomain = ""

  }
)
