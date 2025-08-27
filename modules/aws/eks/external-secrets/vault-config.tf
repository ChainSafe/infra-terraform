locals {
  external_secrets_sa = "external-secrets"
}

data "kubernetes_service_account" "external_secrets" {
  metadata {
    name      = local.external_secrets_sa
    namespace = local.namespace
  }
  depends_on = [
    helm_release.external_secrets
  ]
}

resource "kubernetes_cluster_role_binding_v1" "external_secrets" {
  metadata {
    name = local.external_secrets_sa
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }
  subject {
    kind      = "ServiceAccount"
    name      = local.external_secrets_sa
    namespace = local.external_secrets_sa
  }
}

resource "kubernetes_secret_v1" "external_secrets" {
  metadata {
    generate_name = "${local.external_secrets_sa}-"
    annotations = {
      "kubernetes.io/service-account.name" = data.kubernetes_service_account.external_secrets.metadata[0].name
    }
    namespace = local.namespace
  }

  type = "kubernetes.io/service-account-token"
}

resource "vault_auth_backend" "this" {
  type = "kubernetes"
  path = data.aws_eks_cluster.this.tags["cluster_id"]
  tune {
    listing_visibility = "hidden"
  }
}

resource "vault_kubernetes_auth_backend_config" "this" {
  backend = vault_auth_backend.this.path

  kubernetes_host    = data.aws_eks_cluster.this.endpoint
  kubernetes_ca_cert = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token_reviewer_jwt = kubernetes_secret_v1.external_secrets.data.token

  disable_iss_validation = true
  #  disable_local_ca_jwt   = true
}

# FIXME: Legacy Vault
resource "vault_auth_backend" "legacy" {
  provider = vault.legacy

  type = "kubernetes"
  path = data.aws_eks_cluster.this.tags["cluster_id"]
  tune {
    listing_visibility = "hidden"
  }
}

resource "vault_kubernetes_auth_backend_config" "legacy" {
  provider = vault.legacy

  backend = vault_auth_backend.legacy.path

  kubernetes_host    = data.aws_eks_cluster.this.endpoint
  kubernetes_ca_cert = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token_reviewer_jwt = kubernetes_secret_v1.external_secrets.data.token

  disable_iss_validation = true
  #  disable_local_ca_jwt   = true
}
