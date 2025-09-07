# ---------------------------------------------------------------------------------------------------------------------
# You can find latest template for this module at:
# https://github.com/ChainSafe/infra-terraform/tree/main/modules/aws/eks/security/examples/
# ---------------------------------------------------------------------------------------------------------------------

locals {
  stack_name    = "modules/aws/eks/security"
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
  # Name of the EKS cluster
  #
  # If not provided will use account name
  #
  # Example:
  # * cluster_name = "dev"
  # ---------------------------------------------------------------------------------------------------------------------
  # cluster_name = ""

  # ---------------------------------------------------------------------------------------------------------------------
  # Version of gatekeeper/gatekeeper (defaults "3.20.1")
  #
  # https://github.com/open-policy-agent/gatekeeper/blob/master/charts/gatekeeper/Chart.yaml
  #
  # Example:
  # * gatekeeper_version = "0.1.12"
  # ---------------------------------------------------------------------------------------------------------------------
  # gatekeeper_version = "3.20.1"

  # ---------------------------------------------------------------------------------------------------------------------
  # Extra namespaces to exclude from gatekeeper (defaults [])
  #
  # Example:
  # *
  # ---------------------------------------------------------------------------------------------------------------------
  # gatekeeper_exclude_ns = []

  # ---------------------------------------------------------------------------------------------------------------------
  # Version of oauth2-proxy (defaults "8.2.0")
  #
  # https://github.com/oauth2-proxy/manifests/blob/main/helm/oauth2-proxy/Chart.yaml
  #
  # Example:
  # * oath2_proxy_version = "8.1.0"
  # ---------------------------------------------------------------------------------------------------------------------
  # oath2_proxy_version = "8.2.0"

  # ---------------------------------------------------------------------------------------------------------------------
  # Version of dex (defaults "0.24.0")
  #
  # https://github.com/dexidp/helm-charts/blob/master/charts/dex/Chart.yaml
  #
  # Example:
  # * dex_version = "8.1.0"
  # ---------------------------------------------------------------------------------------------------------------------
  # dex_version = "0.24.0"

}
