resource "keycloak_openid_client" "this" {
  realm_id  = data.keycloak_realm.this.id
  client_id = "vault"
  name      = "vault"

  access_type           = "CONFIDENTIAL"
  standard_flow_enabled = true
  implicit_flow_enabled = true
  valid_redirect_uris = [
    "${local.vault_url}/oidc/callback",
    "${local.vault_url}/ui/vault/auth/oidc/oidc/callback",
  ]

  root_url  = local.vault_url
  admin_url = local.vault_url
  web_origins = [
    "+"
  ]
  base_url = "/"

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

resource "vault_jwt_auth_backend" "oidc" {
  description        = "Keycloak authentication"
  path               = "oidc"
  type               = "oidc"
  oidc_discovery_url = "https://auth.infra.aws.${var.default_variables.global_hosted_zone}/realms/${data.keycloak_realm.this.id}"
  oidc_client_id     = keycloak_openid_client.this.client_id
  oidc_client_secret = keycloak_openid_client.this.client_secret
  default_role       = "keycloak"

  tune {
    listing_visibility = "unauth"
    default_lease_ttl  = "24h"
    max_lease_ttl      = "24h"
    token_type         = "default-service"
  }
}

resource "vault_jwt_auth_backend_role" "oidc" {
  backend   = vault_jwt_auth_backend.oidc.path
  role_name = vault_jwt_auth_backend.oidc.default_role
  token_policies = [
    "default"
  ]
  oidc_scopes = [
    "email",
    "openid",
    "profile",
  ]

  user_claim   = "email"
  groups_claim = "groups"
  role_type    = "oidc"

  allowed_redirect_uris = [
    "${local.vault_url}/ui/vault/auth/${vault_jwt_auth_backend.oidc.path}/oidc/callback",
    "${local.vault_url}/${vault_jwt_auth_backend.oidc.path}/callback"
  ]

  #
  token_ttl     = 14400
  token_max_ttl = 28800
}

resource "vault_policy" "this" {
  for_each = toset([
    "admin",
    "terraform"
  ])

  name   = each.key
  policy = file("${path.module}/policies/${each.key}.hcl")
}

resource "vault_identity_group" "devops" {
  name = lower("devops")
  type = "external"

  policies = [
    vault_policy.this["admin"].name,
    "default"
  ]

  metadata = {
    version = "2"
  }
}

resource "vault_identity_group_alias" "devops" {
  name           = lower("devops")
  mount_accessor = vault_jwt_auth_backend.oidc.accessor
  canonical_id   = vault_identity_group.devops.id
}
