# ---------------------------------------------------------------------------------------------------------------------
# You can find latest template for this module at:
# https://github.com/ChainSafe/infra-terraform/tree/main/modules/aws/eks/cluster/examples/
# ---------------------------------------------------------------------------------------------------------------------

locals {
  stack_name    = "modules/aws/eks/cluster"
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
  # Name of the EKS cluster (defaults "")
  #
  # If not provided will use account name
  #
  # Example:
  # * cluster_name = "dev"
  # ---------------------------------------------------------------------------------------------------------------------
  # cluster_name = ""

  # ---------------------------------------------------------------------------------------------------------------------
  # Map of IAM roles with access to K8s API (defaults {})
  #
  # Example:
  # * eks_map_roles = {
  #   "arn:aws:iam::01234567890:role/Developers" = {
  #     groups = [
  #       "developers"
  #     ]
  #   }
  # }
  # ---------------------------------------------------------------------------------------------------------------------
  # eks_map_roles = {}

  # ---------------------------------------------------------------------------------------------------------------------
  # Configuration of subnets for nodes/control plane(defaults {nodes="private",control_plane="internal",availability_zones=["a","b","c"]})
  #
  # Example:
  # * subnet_types = {
  #   control_plane = "private"
  # }
  # ---------------------------------------------------------------------------------------------------------------------
  # subnet_types = {
  #   availability_zones = [
  #     "a",
  #     "b",
  #     "c"
  # ]
  #   control_plane = "internal"
  #   nodes = "private"
  #   vpc_name = ""
  #  }

  # ---------------------------------------------------------------------------------------------------------------------
  # Target version of the Kubernetes cluster (defaults "1.33")
  #
  # Example:
  # * kubernetes_version = "1.19"
  # ---------------------------------------------------------------------------------------------------------------------
  # kubernetes_version = "1.33"

  # ---------------------------------------------------------------------------------------------------------------------
  # Default nodes configuration (defaults {instance_types=["m6g.large"],min_capacity=2,max_capacity=3})
  #
  # If node group is tainted, it allows only CriticalAddons installation
  #
  # Example:
  # * default_node_group = {
  #     instance_types = ["m5.large"]
  #     min_capacity   = 2
  #     max_capacity   = 3
  #     tainted = true
  # }
  # ---------------------------------------------------------------------------------------------------------------------
  # default_node_group = {
  #   instance_types = [
  #     "m6g.large"
  # ]
  #   max_capacity = 3
  #   min_capacity = 2
  #   tainted = false
  #  }

  # ---------------------------------------------------------------------------------------------------------------------
  # Access CIDRs to Cluster API (defaults ["10.0.0.0/8"])
  #
  # Example:
  # * api_access_cidrs = [
  #   "192.168.1.0/24"
  # ]
  # ---------------------------------------------------------------------------------------------------------------------
  # api_access_cidrs = [
  #   "10.0.0.0/8"
  # ]

  # ---------------------------------------------------------------------------------------------------------------------
  # List of enabled CW logs (defaults ["authenticator"])
  #
  # Available options:
  # * "api"
  # * "audit"
  # * "authenticator"
  # * "controllerManager"
  # * "scheduler"
  #
  # Example:
  # * eks_enabled_log_types = [
  #   "api",
  #   "authenticator",
  #   "controllerManager",
  # ]
  # ---------------------------------------------------------------------------------------------------------------------
  # enabled_log_types = [
  #   "audit",
  #   "authenticator"
  # ]

}
