locals {
  cluster_name = var.cluster_name != "" ? var.cluster_name : replace(var.default_variables.account_name, "-prod", "")
  domain_name = join(".",
    compact([
      replace(var.default_variables.account_name, "-prod", ""),
      "aws",
      var.default_variables.global_hosted_zone
    ])
  )
}

data "aws_organizations_organization" "this" {}

data "aws_eks_cluster" "this" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = data.aws_eks_cluster.this.name
}

locals {
  #noinspection HILUnresolvedReference
  oidc_provider_url = replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")
}
