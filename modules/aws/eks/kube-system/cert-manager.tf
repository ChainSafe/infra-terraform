resource "helm_release" "cert_manager" {
  name      = "cert-manager"
  namespace = "cert-manager"

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = var.cert_manager_version

  create_namespace = true

  values = [
    templatefile(
      "${path.module}/values/cert-manager.yaml",
      {
        namespace = "cert-manager"
        cluster   = data.aws_eks_cluster.this.name
      }
    )
  ]
}

resource "kubectl_manifest" "cert_issuers" {
  for_each = toset([
    "letsencrypt",
  ])
  yaml_body = templatefile(
    "${path.module}/manifests/cert-manager/${each.key}.yaml",
    {
      email_domain = var.default_variables.email_domain
    }
  )

  depends_on = [
    helm_release.cert_manager
  ]
}
