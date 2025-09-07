resource "vault_mount" "kv" {
  path = "kv"
  type = "kv-v2"
}

resource "vault_mount" "database" {
  path = "database"
  type = "database"
}

resource "vault_mount" "personal" {
  path = "personal"
  type = "kv-v2"
}
