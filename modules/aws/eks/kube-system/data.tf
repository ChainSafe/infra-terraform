locals {
  vpc_name         = "main"
  eks_cluster_name = var.cluster_name != "" ? var.cluster_name : replace(var.default_variables.account_name, "-prod", "")
  domain_name = join(".",
    compact([
      replace(var.default_variables.account_name, "-prod", ""),
      "aws",
      var.default_variables.global_hosted_zone
    ])
  )
}

data "aws_eks_cluster" "this" {
  name = local.eks_cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = data.aws_eks_cluster.this.name
}

data "aws_vpc" "this" {
  tags = {
    Name = local.vpc_name
  }
}

data "aws_subnets" "private" {
  filter {
    name = "vpc-id"
    values = [
      data.aws_vpc.this.id
    ]
  }
  tags = {
    Tier = "private"
  }
}

data "aws_subnets" "public" {
  filter {
    name = "vpc-id"
    values = [
      data.aws_vpc.this.id
    ]
  }
  tags = {
    Tier = "public"
  }
}

data "aws_security_group" "node" {
  vpc_id = data.aws_vpc.this.id
  tags = {
    Name = "${data.aws_eks_cluster.this.name}-node"
  }
}

locals {
  # noinspection HILUnresolvedReference
  oidc_provider_url = replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")
}

data "kubernetes_all_namespaces" "this" {}

data "aws_route53_zone" "public" {
  name = local.domain_name
}
