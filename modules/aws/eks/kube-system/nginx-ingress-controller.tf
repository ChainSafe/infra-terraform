resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  version    = var.ingress_nginx_version

  create_namespace = true

  values = [
    templatefile(
      "${path.module}/values/ingress-nginx.yaml",
      {
        cluster_name      = local.eks_cluster_name
        route53_subdomain = local.eks_cluster_name
        route53_domain    = "example.com"
      }
    )
  ]

  depends_on = [
    kubectl_manifest.crds,
    helm_release.alb_ingress,
    helm_release.cert_manager
  ]
}
