locals {
  eks_cluster_name = var.eks_cluster_name != "" ? var.eks_cluster_name : replace(var.default_variables.account_name, "${var.default_variables.organization}-", "")
}

data "aws_eks_cluster" "this" {
  name = local.eks_cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = data.aws_eks_cluster.this.name
}
