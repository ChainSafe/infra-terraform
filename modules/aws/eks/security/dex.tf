resource "kubernetes_secret_v1" "dex" {
  metadata {
    name      = "dex-config"
    namespace = local.namespace
  }
  data = {
    "config.yaml" = templatefile(
      "${path.module}/values/dex-config.yaml",
      {
        client_id     = tostring(data.vault_kv_secret_v2.oauth.data.client_id)
        client_secret = tostring(data.vault_kv_secret_v2.oauth.data.client_secret)
        dex_dns       = "auth.${local.domain_name}"
        domain        = local.domain_name
        organization  = var.default_variables.organization
        email_domain  = var.default_variables.email_domain
        static_clients = {
          awx = "https://awx.${local.domain_name}/sso/complete/oidc/"
          ara = "https://awx.${local.domain_name}/oauth2/callback"
        }
      }
    )
  }
}

resource "helm_release" "dex" {
  name       = "dex"
  chart      = "dex"
  version    = var.dex_version
  repository = "https://charts.dexidp.io"
  namespace  = local.namespace

  values = [
    templatefile(
      "${path.module}/values/dex.yaml",
      {
        dex_config = kubernetes_secret_v1.dex.metadata[0].name
        dex_dns    = "auth.${local.domain_name}"
      }
    )
  ]
}
