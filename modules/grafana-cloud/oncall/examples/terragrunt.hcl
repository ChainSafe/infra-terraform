# ---------------------------------------------------------------------------------------------------------------------
# You can find latest template for this module at:
# https://github.com/ChainSafe/infra-terraform/tree/main/modules/grafana-cloud/oncall/examples/
# ---------------------------------------------------------------------------------------------------------------------

locals {
  stack_name    = "modules/grafana-cloud/oncall"
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
inputs = {
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
  # Name of the on-call team
  #
  # Example:
  # * team_name = "devops"
  # ---------------------------------------------------------------------------------------------------------------------
  team_name =

  # ---------------------------------------------------------------------------------------------------------------------
  # List of on-call users (defaults [])
  #
  # Example:
  # * team_members = [
  #   "adobrodey"
  # ]
  # ---------------------------------------------------------------------------------------------------------------------
  # team_members = []

  # ---------------------------------------------------------------------------------------------------------------------
  # List of team managers (defaults [])
  #
  # Example:
  # * team_managers = [
  #   "joshdougall"
  # ]
  # ---------------------------------------------------------------------------------------------------------------------
  # team_managers = []

}
