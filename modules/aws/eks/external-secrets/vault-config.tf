resource "vault_auth_backend" "this" {
  type = "kubernetes"
  path = data.aws_eks_cluster.this.name
  tune {
    listing_visibility = "hidden"
  }
}

data "kubernetes_service_account_v1" "external_secrets" {
  metadata {
    name      = local.external_secrets_sa
    namespace = local.namespace
  }
  depends_on = [
    helm_release.external_secrets
  ]
}

resource "kubernetes_secret_v1" "external_secrets" {
  metadata {
    name      = "${local.external_secrets_sa}-token"
    namespace = local.namespace
    annotations = {
      "kubernetes.io/service-account.name" = data.kubernetes_service_account_v1.external_secrets.metadata[0].name
    }
  }

  type = "kubernetes.io/service-account-token"
}

resource "vault_kubernetes_auth_backend_config" "this" {
  backend = vault_auth_backend.this.path

  kubernetes_host    = data.aws_eks_cluster.this.endpoint
  kubernetes_ca_cert = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token_reviewer_jwt = kubernetes_secret_v1.external_secrets.data.token

  disable_iss_validation = true
  #  disable_local_ca_jwt   = true
}
