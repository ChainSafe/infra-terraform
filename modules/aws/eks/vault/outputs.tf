output "vault_url" {
  description = "Vault URL"
  value       = "https://${local.service_dns}"
}
