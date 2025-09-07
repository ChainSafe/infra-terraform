module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> v21.0"

  name                                     = local.cluster_name
  kubernetes_version                       = var.kubernetes_version
  endpoint_public_access                   = var.subnet_types.control_plane == "public"
  enable_cluster_creator_admin_permissions = true

  addons                   = local.cluster_addons
  iam_role_use_name_prefix = false
  endpoint_public_access_cidrs = [
    "0.0.0.0/0"
  ]

  addons_timeouts = {
    create = "5m"
    update = "5m"
    delete = "5m"
  }

  # Encryption
  create_kms_key = true
  kms_key_owners = data.aws_iam_roles.administrators.arns
  encryption_config = {
    resources = ["secrets"]
  }


  kms_key_deletion_window_in_days = 7
  enable_kms_key_rotation         = true

  # Networking
  vpc_id                   = data.aws_vpc.this.id
  subnet_ids               = data.aws_subnets.nodes.ids
  control_plane_subnet_ids = local.control_plane_subnet_ids

  security_group_additional_rules = local.cluster_security_group_additional_rules

  # Extend node-to-node security group rules
  node_security_group_additional_rules = local.node_security_group_additional_rules

  eks_managed_node_groups = {
    default = {
      name         = "${local.cluster_name}-default"
      min_size     = var.default_node_group.min_capacity
      desired_size = var.default_node_group.min_capacity
      max_size     = var.default_node_group.max_capacity

      ami_type       = "BOTTLEROCKET_ARM_64"
      platform       = "bottlerocket"
      instance_types = var.default_node_group.instance_types
      capacity_type  = "ON_DEMAND"

      bootstrap_extra_args = <<-EOT
        # extra args added
        [settings.kernel]
        lockdown = "integrity"

        [settings.host-containers.admin]
        enabled = true
        [settings.host-containers.control]
        enabled = true
      EOT

      block_device_mappings = {
        "xvda" = {
          device_name = "/dev/xvda"
          ebs = {
            delete_on_termination = true
            encrypted             = true
            volume_type           = "gp3"
            throughput            = 500
            volume_size           = 2
          }
        }
        "xvdb" = {
          device_name = "/dev/xvdb"
          ebs = {
            delete_on_termination = true
            encrypted             = true
            volume_type           = "gp3"
            throughput            = 500
            volume_size           = 20
          }
        }
      }

      vpc_security_group_ids = [
        aws_security_group.additional.id
      ]

      create_iam_role      = false
      iam_role_arn         = aws_iam_role.eks_managed.arn
      force_update_version = true

      labels = merge(
        {
          nodegroup                 = "default"
          "node.kubernetes.io/role" = "default"
        }
      )

      taints = var.default_node_group.tainted ? {
        addons = {
          key    = "CriticalAddonsOnly"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
      } : null

      tags = merge(
        local.global_tags,
        var.tags,
        {
          Name = "${local.cluster_name}-ng-default"
        }
      )

      update_config = {
        max_unavailable_percentage = 50 # or set `max_unavailable`
      }
    }
  }

  kms_key_enable_default_policy = false

  enabled_log_types                      = var.enabled_log_types
  cloudwatch_log_group_retention_in_days = 7

  node_security_group_tags = {
    # https://github.com/hashicorp/terraform-provider-kubernetes/issues/1028
    "kubernetes.io/cluster/${local.cluster_name}"  = null
    "karpenter.sh/discovery/${local.cluster_name}" = "1"
  }

  tags = merge(
    local.global_tags,
    var.tags,
    {
      Name = local.cluster_name
    }
  )

  depends_on = [
    aws_iam_role_policy_attachment.eks_managed,
  ]
}
