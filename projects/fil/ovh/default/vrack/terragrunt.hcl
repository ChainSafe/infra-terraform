# ---------------------------------------------------------------------------------------------------------------------
# You can find latest template for this module at:
# https://github.com/ChainSafe/infra-terraform/tree/main/modules/ovh/vrack/examples/
# ---------------------------------------------------------------------------------------------------------------------

locals {
  stack_name    = "modules/ovh/vrack"
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
    # List of dedicated servers to attach to vRack (defaults [])
    #
    # Example:
    # * dedicated_servers = [
    #   "nsxxxxxx.ip-xx-xx-xx.eu"
    # ]
    # ---------------------------------------------------------------------------------------------------------------------
    dedicated_servers = [
      "ns3220252.ip-162-19-82.eu",  # fil-prod-ovh-forest-calibnet-archive
      "ns3262103.ip-57-128-233.eu", # fil-prod-ovh-forest-calibnet-snapshots-backfil ->
      # mainnet-archive
    ]
  }
)
