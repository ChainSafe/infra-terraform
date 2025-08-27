data "aws_iam_policy_document" "eks_managed_assume_role_policy" {
  statement {
    sid     = "EKSNodeAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ec2.${data.aws_partition.current.dns_suffix}"
      ]
    }
  }
}

data "aws_iam_policy_document" "vpc_cni_irsa_assume" {
  statement {
    sid     = "EKSVPCAssumeRole"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      identifiers = [
        module.eks.oidc_provider_arn
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider_arn, "/^(.*provider/)/", "")}:sub"
      values = [
        "system:serviceaccount:kube-system:aws-node"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider_arn, "/^(.*provider/)/", "")}:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "ebs_csi_irsa_assume" {
  statement {
    sid     = "EBSAssumeRole"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      identifiers = [
        module.eks.oidc_provider_arn
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider_arn, "/^(.*provider/)/", "")}:sub"
      values = [
        "system:serviceaccount:kube-system:ebs-csi-controller-sa"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider_arn, "/^(.*provider/)/", "")}:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "efs_csi_irsa_assume" {
  statement {
    sid     = "EFSAssumeRole"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      identifiers = [
        module.eks.oidc_provider_arn
      ]
    }
    condition {
      test     = "StringLike"
      variable = "${replace(module.eks.oidc_provider_arn, "/^(.*provider/)/", "")}:sub"
      values = [
        "system:serviceaccount:kube-system:efs-csi-*"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider_arn, "/^(.*provider/)/", "")}:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "eks_managed" {
  name = "${local.cluster_name}-eks-managed"

  assume_role_policy    = data.aws_iam_policy_document.eks_managed_assume_role_policy.json
  force_detach_policies = true

  tags = merge(
    var.tags,
    {
      Name = "${local.cluster_name}-eks-managed"
    }
  )
}

resource "aws_iam_role" "vpc_cni_irsa" {
  name = "${local.cluster_name}-vpc-cni"

  assume_role_policy    = data.aws_iam_policy_document.vpc_cni_irsa_assume.json
  force_detach_policies = true

  tags = merge(
    var.tags,
    {
      Name = "${local.cluster_name}-vpc-cni"
    }
  )
}

resource "aws_iam_role" "ebs_csi_irsa" {
  name = "${local.cluster_name}-ebs-csi"

  assume_role_policy    = data.aws_iam_policy_document.ebs_csi_irsa_assume.json
  force_detach_policies = true

  tags = merge(
    var.tags,
    {
      Name = "${local.cluster_name}-ebs-csi"
    }
  )
}

resource "aws_iam_role" "efs_csi_irsa" {
  name = "${local.cluster_name}-efs-csi"

  assume_role_policy    = data.aws_iam_policy_document.efs_csi_irsa_assume.json
  force_detach_policies = true

  tags = merge(
    var.tags,
    {
      Name = "${local.cluster_name}-efs-csi"
    }
  )
}

# Policies attached ref https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group
resource "aws_iam_role_policy_attachment" "eks_managed" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ])

  policy_arn = each.value
  role       = aws_iam_role.eks_managed.name
}

resource "aws_iam_role_policy_attachment" "vpc_cni_irsa" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.vpc_cni_irsa.name
}

resource "aws_iam_role_policy_attachment" "ebs_csi_irsa" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_irsa.name
}

resource "aws_iam_role_policy_attachment" "efs_csi_irsa" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
  role       = aws_iam_role.efs_csi_irsa.name
}
