resource "kubernetes_namespace" "external_secrets" {
  metadata {
    name = "external-secrets"
  }
}

locals {
  namespace           = kubernetes_namespace.external_secrets.metadata[0].name
  external_secrets_sa = "external-secrets"
}

resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  chart      = "external-secrets"
  version    = var.external_secrets_version
  repository = "https://charts.external-secrets.io/"

  namespace    = local.namespace
  force_update = true

  values = [
    templatefile(
      "${path.module}/values/external-secrets.yaml",
      {
        external_secrets_sa = local.external_secrets_sa
      }
    )
  ]
}
