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

data "aws_eks_cluster" "this" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = data.aws_eks_cluster.this.name
}

data "vault_kv_secret_v2" "keycloak" {
  mount = "infra"
  name  = "platform/keycloak"
}

data "keycloak_realm" "this" {
  realm = "internal"
}
