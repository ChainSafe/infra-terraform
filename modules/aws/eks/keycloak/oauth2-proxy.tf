resource "random_password" "oauth2_cookie_secret" {
  length           = 32
  override_special = "-_"
}

resource "keycloak_openid_client" "oauth2" {
  realm_id  = keycloak_realm.this.id
  client_id = "oauth2-proxy"
  name      = "oauth2-proxy"

  access_type           = "CONFIDENTIAL"
  standard_flow_enabled = true
  implicit_flow_enabled = true
  valid_redirect_uris = [
    "https://internal.${local.domain_name}/oauth2/callback",
  ]

  web_origins = [
    "+"
  ]
  base_url = "/"

  login_theme = "keycloak"
}


resource "kubernetes_secret_v1" "oauth_proxy" {
  metadata {
    name      = "oauth2-proxy-config"
    namespace = local.namespace
  }
  data = {
    "client-id" : keycloak_openid_client.oauth2.client_id
    "client-secret" : keycloak_openid_client.oauth2.client_secret
    "cookie-secret" : random_password.oauth2_cookie_secret.result
  }
}

resource "helm_release" "oauth2_proxy" {
  name       = "oauth2"
  chart      = "oauth2-proxy"
  version    = var.oath2_proxy_version
  repository = "https://oauth2-proxy.github.io/manifests"
  namespace  = local.namespace

  values = [
    templatefile(
      "${path.module}/values/oauth2-proxy.yaml",
      {
        oidc_issuer_url  = "https://${local.keycloak_dns}/realms/${keycloak_realm.this.id}"
        oauth2_proxy_dns = "internal.${local.domain_name}"
        oauth2_secret    = kubernetes_secret_v1.oauth_proxy.metadata[0].name
        email_domain     = var.default_variables.email_domain
        domain           = local.domain_name
        upstreams        = []
      }
    )
  ]
}
