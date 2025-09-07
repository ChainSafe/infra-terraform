resource "vault_jwt_auth_backend" "github" {
  description        = "OIDC auth backend for github actions"
  path               = "github"
  oidc_discovery_url = "https://token.actions.githubusercontent.com"
  bound_issuer       = "https://token.actions.githubusercontent.com"

  tune {
    listing_visibility = "hidden"
    default_lease_ttl  = "1h"
    max_lease_ttl      = "1h"
    token_type         = "default-service"
  }
}
