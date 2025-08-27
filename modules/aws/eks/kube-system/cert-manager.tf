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
