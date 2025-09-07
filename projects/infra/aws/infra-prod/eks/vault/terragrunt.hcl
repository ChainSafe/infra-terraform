# ---------------------------------------------------------------------------------------------------------------------
# You can find latest template for this module at:
# https://github.com/ChainSafe/infra-terraform/tree/main/modules/aws/eks/vault/examples/
# ---------------------------------------------------------------------------------------------------------------------

locals {
  stack_name    = "modules/aws/eks/vault"
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

dependency "cluster" {
  config_path = "../cluster"

  mock_outputs = {
    cluster_name = "fake-name"
  }
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
  # Name of the EKS cluster
  #
  # If not provided will use account name
  #
  # Example:
  # * cluster_name = "dev"
  # ---------------------------------------------------------------------------------------------------------------------
  cluster_name = dependency.cluster.outputs.cluster_name

  # ---------------------------------------------------------------------------------------------------------------------
  # Version of hashicorp/vault (defaults "0.30.1")
  #
  # https://github.com/hashicorp/vault-helm/blob/master/Chart.yaml
  #
  # Example:
  # * vault_version = "0.9.0"
  # ---------------------------------------------------------------------------------------------------------------------
  # vault_version = "0.30.1"

}
