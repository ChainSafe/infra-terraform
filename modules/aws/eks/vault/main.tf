resource "kubernetes_namespace" "this" {
  metadata {
    name = "vault"
  }
}

locals {
  namespace   = kubernetes_namespace.this.metadata[0].name
  service_dns = "vault.${local.domain_name}"
}

resource "helm_release" "this" {
  name      = "vault-server"
  namespace = local.namespace

  chart      = "vault"
  version    = var.vault_version
  repository = "https://helm.releases.hashicorp.com"

  values = [
    templatefile(
      "${path.module}/values/vault.yaml",
      {
        cluster_name         = data.aws_eks_cluster.this.name
        namespace            = local.namespace
        host_url             = local.service_dns
        unseal_key_id        = aws_kms_key.vault_unseal.key_id
        aws_region           = var.default_variables.region
        role_arn             = aws_iam_role.this.arn
        bootstrap_secret     = kubernetes_secret.bootstrap.metadata[0].name
        service_account_name = local.vault_sa
      }
    ),
  ]
}
