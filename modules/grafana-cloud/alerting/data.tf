data "vault_kv_secret_v2" "grafana" {
  mount = "infra"
  name  = "platform/grafana-cloud"
}

data "vault_kv_secret_v2" "pagerduty" {
  mount = "infra"
  name  = "platform/pagerduty"
}

data "pagerduty_escalation_policy" "this" {
  name = var.pd_escalation_policy
}

data "grafana_synthetic_monitoring_probes" "this" {}
