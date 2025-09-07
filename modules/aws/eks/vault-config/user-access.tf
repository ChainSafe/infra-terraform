# resource "vault_policy" "personal" {
#   name   = "personal"
#   policy = <<EOT
# # Grant permissions on user specific path
# path "${vault_mount.personal.path}/data/{{identity.entity.aliases.${vault_jwt_auth_backend.oidc.accessor}.name}}/*" {
#     capabilities = ["create", "update", "read", "delete", "list"]
# }
#
# # For Web UI usage
# path "${vault_mount.personal.path}/metadata" {
#   capabilities = ["list"]
# }
# EOT
# }

resource "vault_identity_group" "admins" {
  name = lower("${var.default_variables.organization}-proj-pleng-platform-adm")
  type = "external"

  policies = [
    "admins",
    "default"
  ]

  metadata = {
    version = "2"
  }
}

# resource "vault_identity_group_alias" "admins" {
#   name           = lower("${var.default_variables.organization}-proj-pleng-platform-adm")
#   mount_accessor = vault_jwt_auth_backend.oidc.accessor
#   canonical_id   = vault_identity_group.admins.id
# }
