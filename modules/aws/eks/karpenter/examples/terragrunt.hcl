# ---------------------------------------------------------------------------------------------------------------------
# You can find latest template for this module at:
# https://github.com/ChainSafe/infra-terraform/tree/main/modules/aws/eks/karpenter/examples/
# ---------------------------------------------------------------------------------------------------------------------

locals {
  stack_name    = "modules/aws/eks/karpenter"
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
  # Name of the EKS cluster
  #
  # Example:
  # * cluster_name = "dev"
  # ---------------------------------------------------------------------------------------------------------------------
  # cluster_name = ""

  # ---------------------------------------------------------------------------------------------------------------------
  # Version of karpenter/karpenter (defaults "1.6.3")
  #
  # https://gallery.ecr.aws/karpenter/karpenter
  #
  # Example:
  # * karpenter_version = "1.7.0"
  # ---------------------------------------------------------------------------------------------------------------------
  # karpenter_version = "1.6.3"

  # ---------------------------------------------------------------------------------------------------------------------
  # Configuration of the additional node groups (defaults {})
  #
  # Options:
  # * max_cpu - Maximum number of CPU for the Node Group (defaults 20)
  # * class - Node Class, one of "bottlerocket" or "al2023" (defaults "bottlerocket")
  # * hypervisor - AWS instance hypervisor (defaults "nitro")
  # * family - List of instance families (defaults ["m6"])
  # * cpu - List of CPU options (defaults [4])
  # * is_spot - If the instance is Spot (defaults true)
  # * tainted - If the node is Tainted by default (defaults false)
  #
  # More details:
  # https://aws.amazon.com/ec2/instance-types/
  #
  # Example:
  # * node_groups = {
  #   cpu_optimized = {
  #     max_cpu = 30
  #     family = ["c5"]
  #     cpu = [4, 8]
  #     is_spot = false
  #     tainted = true
  #   }
  # }
  # ---------------------------------------------------------------------------------------------------------------------
  # node_groups = {}

}
