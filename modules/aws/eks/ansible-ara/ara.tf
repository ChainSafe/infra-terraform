
resource "helm_release" "ara" {
  name      = "ara"
  namespace = local.namespace

  chart      = "ara"
  version    = var.ara_version
  repository = "https://lib42.github.io/charts"

  values = [
    templatefile(
      "${path.module}/values/ara.yaml",
      {
        ara_dns   = local.ara_dns
        oauth_dns = local.oauth_dns
      }
    )
  ]
}
