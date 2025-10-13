resource "vault_kv_secret_v2" "this" {
  mount = "infra"
  name  = "platform/keycloak"
  data_json = jsonencode({
    username = "admin"
    password = random_uuid.admin.result
  })
}
