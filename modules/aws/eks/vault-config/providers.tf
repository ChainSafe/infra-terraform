provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "vault" {
  address               = "https://vault.infra.aws.${var.default_variables.global_hosted_zone}"
  max_lease_ttl_seconds = 1800

  auth_login_aws {
    role                  = local.terraform_role_name
    aws_role_arn          = "arn:aws:iam::${var.default_variables.platform_account_id}:role/${local.terraform_role_name}"
    aws_role_session_name = "vault"
  }
}

# provider "okta" {
#   org_name    = var.vault_okta_auth_config.okta_org_name
#   base_url    = var.vault_okta_auth_config.okta_domain
#   client_id   = var.vault_okta_auth_config.client_id
#   private_key = var.vault_okta_auth_config.private_key
#   scopes = [
#     "okta.groups.read",
#     "okta.users.read",
#     # "okta.apps.manage"
#   ]
# }
