resource "kubernetes_namespace" "this" {
  metadata {
    name = "ansible"
  }
}

locals {
  namespace = kubernetes_namespace.this.metadata[0].name
}

resource "helm_release" "awx" {
  name      = "awx"
  namespace = local.namespace

  chart      = "awx-operator"
  version    = var.awx_operator_version
  repository = "https://ansible-community.github.io/awx-operator-helm/"

  values = [
    templatefile(
      "${path.module}/values/awx-operator.yaml",
      {
        awx_dns     = local.awx_dns
        auth_secret = kubernetes_secret_v1.awx_auth.metadata[0].name
      }
    )
  ]
}
