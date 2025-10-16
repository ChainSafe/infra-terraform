resource "keycloak_openid_client" "this" {
  realm_id  = data.keycloak_realm.this.id
  client_id = "awx"
  name      = "awx"

  access_type           = "CONFIDENTIAL"
  standard_flow_enabled = true
  implicit_flow_enabled = true
  valid_redirect_uris = [
    "https://${local.awx_dns}/sso/complete/oidc/",
  ]

  root_url  = "https://${local.awx_dns}"
  admin_url = "https://${local.awx_dns}"
  web_origins = [
    "+"
  ]

  login_theme = "keycloak"
}


resource "keycloak_openid_group_membership_protocol_mapper" "groups" {
  realm_id  = data.keycloak_realm.this.id
  client_id = keycloak_openid_client.this.id

  name       = "groups"
  claim_name = "groups"

  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true
  full_path           = false
}

resource "keycloak_openid_client_default_scopes" "this" {
  realm_id  = data.keycloak_realm.this.id
  client_id = keycloak_openid_client.this.id

  default_scopes = [
    "email",
    "groups",
    "profile",
  ]
}

resource "kubernetes_secret_v1" "awx_auth" {
  metadata {
    name      = "awx-keycloak-auth"
    namespace = local.namespace
  }

  data = {
    "keycloak.py" = <<EOF
SOCIAL_AUTH_OIDC_KEY = "${keycloak_openid_client.this.client_id}"
SOCIAL_AUTH_OIDC_SECRET = "${keycloak_openid_client.this.client_secret}"
SOCIAL_AUTH_OIDC_OIDC_ENDPOINT = "${local.keycloak_url}/realms/${data.keycloak_realm.this.id}"
EOF
  }
}
