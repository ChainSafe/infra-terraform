resource "vault_kv_secret_v2" "this" {
  mount = "infra"
  name  = "platform/keycloak"
  data_json = jsonencode({
    username = "admin"
    password = random_uuid.admin.result
  })
}

resource "vault_kv_secret_v2" "htpasswd" {
  mount = "infra"
  name  = "platform/keycloak-htpasswd"
  data_json = jsonencode({
    for user in var.oauth2_api_users :
    user => random_uuid.oauth2[user].result
  })
}
