#tfsec:ignore:aws-kms-auto-rotate-keys
resource "aws_kms_key" "vault_unseal" {
  description = "Vault auto-unseal key"
}

resource "aws_kms_alias" "vault_unseal" {
  target_key_id = aws_kms_key.vault_unseal.key_id
  name          = "alias/vault-auto-unseal"
}
