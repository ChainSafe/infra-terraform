resource "helm_release" "reloader" {
  name       = "reloader"
  chart      = "reloader"
  version    = var.secrets_reloader_version
  repository = "https://stakater.github.io/stakater-charts"

  namespace    = local.namespace
  force_update = true

  values = [
    templatefile(
      "${path.module}/values/reloader.yaml",
      {

      }
    )
  ]
}
