data "vault_kv_secret_v2" "grafana" {
  mount = "infra"
  name  = "platform/grafana-cloud"
}

data "grafana_team" "this" {
  name = var.team_name
}

data "grafana_oncall_team" "this" {
  name = data.grafana_team.this.name
}

data "grafana_oncall_users" "this" {}
