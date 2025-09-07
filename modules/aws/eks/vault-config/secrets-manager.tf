data "vault_generic_secret" "unseal" {
  path = "infra/root_token"
}

resource "aws_secretsmanager_secret" "this" {
  name                    = "vault-unseal"
  description             = "Vault admin credentials"
  recovery_window_in_days = 0

  tags = merge(
    var.tags,
    {
      Name = "vault-unseal"
    }
  )
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = data.vault_generic_secret.unseal.data_json
}
