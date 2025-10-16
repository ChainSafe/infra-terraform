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
