resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"

  tune {
    listing_visibility = "hidden"
  }
}

resource "vault_auth_backend" "approle" {
  type = "approle"

  tune {
    listing_visibility = "hidden"
  }
}


resource "kubernetes_secret_v1" "kubernetes" {
  metadata {
    generate_name = "kubernetes-backend"
    annotations = {
      "kubernetes.io/service-account.name" = data.kubernetes_service_account.this.metadata[0].name
    }
    namespace = "vault"
  }

  type = "kubernetes.io/service-account-token"
}


resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  backend                = vault_auth_backend.kubernetes.path
  kubernetes_host        = data.aws_eks_cluster.this.endpoint
  kubernetes_ca_cert     = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token_reviewer_jwt     = kubernetes_secret_v1.kubernetes.data.token
  disable_iss_validation = true
}
