data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

locals {
  eks_cluster_name = data.aws_eks_cluster.this.name
}

data "aws_eks_cluster_auth" "this" {
  name = local.eks_cluster_name
}

data "aws_iam_role" "eks_node" {
  name = "${local.eks_cluster_name}-eks-managed"
}
