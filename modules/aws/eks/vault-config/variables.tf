variable "cluster_name" {
  type        = string
  description = <<DESC
Name of the EKS cluster

If not provided will use account name

Example:
* cluster_name = "dev"
DESC
  default     = ""
}

# variable "vault_okta_auth_config" {
#   type = object({
#     okta_org_name = optional(string, "cs")
#     okta_domain   = optional(string, "okta.com")
#     client_id     = string
#     private_key   = string
#   })
#   description = <<DESC
# Configuration of the Okta authentication
#
# Example:
# vault_okta_auth_config:
#   okta_org_name: "example"
#   okta_domain: "okta.com"
#   client_id: "12356789"
#   private_key: |
#     -----BEGIN PRIVATE KEY-----
#     ....
#     -----END PRIVATE KEY-----
# DESC
#   sensitive   = true
# }

# variable "vault_oidc_config" {
#   type = object({
#     okta_client_id     = string
#     okta_client_secret = string
#   })
#   description = <<DESC
# Configuration of the Vault OIDC endpoint in Okta
#
# Example:
# vault_oidc_config:
#   okta_client_id: "12356789"
#   okta_client_secret: "SomeSecretValue"
# DESC
#   sensitive   = true
# }
