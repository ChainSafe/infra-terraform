provider "grafana" {
  url             = "https://${lower(var.default_variables.organization)}.grafana.net/"
  auth            = data.vault_kv_secret_v2.grafana.data.token
  sm_url          = "https://synthetic-monitoring-api-us-east-0.grafana.net"
  sm_access_token = data.vault_kv_secret_v2.grafana.data.sm_token
}

provider "pagerduty" {
  token = data.vault_kv_secret_v2.pagerduty.data.api_token
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
