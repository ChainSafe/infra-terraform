# resource "vault_okta_auth_backend" "this" {
#   organization = "example"
# }

locals {
  oidc_role_name = "oidc"
}

# resource "vault_jwt_auth_backend" "oidc" {
#   description        = "SSO authentication"
#   path               = "oidc"
#   type               = "oidc"
#   oidc_discovery_url = "https://${var.vault_okta_auth_config.okta_org_name}.${var.vault_okta_auth_config.okta_domain}/oauth2/default"
#   oidc_client_id     = var.vault_oidc_config.okta_client_id
#   oidc_client_secret = var.vault_oidc_config.okta_client_secret
#   default_role       = local.oidc_role_name
#
#   tune {
#     listing_visibility = "unauth"
#     default_lease_ttl  = "24h"
#     max_lease_ttl      = "24h"
#     token_type         = "default-service"
#   }
# }

# resource "vault_jwt_auth_backend_role" "oidc" {
#   backend   = vault_jwt_auth_backend.oidc.path
#   role_name = local.oidc_role_name
#   token_policies = [
#     vault_policy.personal.name,
#     "default"
#   ]
#
#   user_claim   = "email"
#   groups_claim = "groups"
#   role_type    = "oidc"
#   allowed_redirect_uris = [
#     "${local.vault_url}/ui/vault/auth/${vault_jwt_auth_backend.oidc.path}/oidc/callback",
#     "http://localhost:8250/oidc/callback"
#   ]
#
#   oidc_scopes = [
#     "openid",
#     "profile",
#     "email",
#   ]
#
#   token_ttl     = 14400
#   token_max_ttl = 28800
# }
