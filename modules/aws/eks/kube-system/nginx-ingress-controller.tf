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
        cluster_name   = local.eks_cluster_name
        route53_domain = local.domain_name
      }
    )
  ]

  depends_on = [
    kubectl_manifest.crds,
    helm_release.alb_ingress,
    helm_release.cert_manager
  ]
}

data "kubernetes_service_v1" "ingress_nginx" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }

  depends_on = [
    helm_release.ingress_nginx
  ]
}


data "aws_acm_certificate" "ingress_nginx" {
  domain   = "*.${local.domain_name}"
  statuses = ["ISSUED"]
}

resource "kubectl_manifest" "ingress_nginx" {
  yaml_body = templatefile(
    "${path.module}/manifests/ingress-nginx.yaml",
    {
      namespace          = "ingress-nginx"
      nginx_service_name = data.kubernetes_service_v1.ingress_nginx.metadata[0].name
      healthcheck_port   = data.kubernetes_service_v1.ingress_nginx.spec[0].port[0].node_port
      acm_cert           = data.aws_acm_certificate.ingress_nginx.arn
      route53_domain     = local.domain_name
    }
  )

  depends_on = [
    helm_release.ingress_nginx
  ]
}
