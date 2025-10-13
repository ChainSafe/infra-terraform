resource "kubernetes_namespace" "this" {
  metadata {
    name = "ansible"
  }
}

locals {
  namespace = kubernetes_namespace.this.metadata[0].name
  oauth_dns = "internal.${local.domain_name}"
  awx_dns   = "ansible.${local.domain_name}"
  ara_dns   = "ara.${local.domain_name}"
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
        awx_dns   = local.awx_dns
        oauth_dns = local.oauth_dns
      }
    )
  ]
}
