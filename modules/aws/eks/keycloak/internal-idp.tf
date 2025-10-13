resource "keycloak_realm" "this" {
  realm   = "internal"
  enabled = true

  display_name      = "internal"
  display_name_html = "<b>internal</b>"

  depends_on = [
    helm_release.this
  ]
}

resource "keycloak_authentication_flow" "this" {
  realm_id = keycloak_realm.this.id
  alias    = "detect-existing-user"
}

resource "keycloak_authentication_execution" "detect_existing" {
  authenticator     = "idp-detect-existing-broker-user"
  parent_flow_alias = keycloak_authentication_flow.this.alias
  realm_id          = keycloak_authentication_flow.this.realm_id
  requirement       = "REQUIRED"
}

resource "keycloak_authentication_execution" "auto_link" {
  authenticator     = "idp-auto-link"
  parent_flow_alias = keycloak_authentication_flow.this.alias
  realm_id          = keycloak_authentication_flow.this.realm_id
  requirement       = "REQUIRED"
}

resource "keycloak_openid_client_scope" "groups" {
  realm_id               = keycloak_realm.this.id
  name                   = "groups"
  description            = "When requested, this scope will map a user's group memberships to a claim"
  include_in_token_scope = true
  gui_order              = 1
}

resource "keycloak_oidc_github_identity_provider" "this" {
  realm         = keycloak_realm.this.id
  client_id     = data.vault_kv_secret_v2.keycloak_auth.data.client_id
  client_secret = data.vault_kv_secret_v2.keycloak_auth.data.client_secret
  trust_email   = true
  sync_mode     = "IMPORT"
}
