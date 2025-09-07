locals {
  cluster_name = var.cluster_name != "" ? var.cluster_name : replace(var.default_variables.account_name, "-prod", "")
}

data "aws_eks_cluster" "this" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = data.aws_eks_cluster.this.name
}
