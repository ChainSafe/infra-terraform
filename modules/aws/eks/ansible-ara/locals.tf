locals {
  keycloak_url = "https://auth.infra.aws.${var.default_variables.global_hosted_zone}"
  vault_url    = "https://vault.infra.aws.${var.default_variables.global_hosted_zone}"
  oauth_dns    = "internal.${local.domain_name}"
  awx_dns      = "ansible.${local.domain_name}"
  ara_dns      = "ara.${local.domain_name}"
}
