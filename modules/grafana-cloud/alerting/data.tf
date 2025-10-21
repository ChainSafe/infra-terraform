data "vault_kv_secret_v2" "grafana" {
  mount = "infra"
  name  = "platform/grafana-cloud"
}

data "grafana_synthetic_monitoring_probes" "this" {}

data "grafana_data_source" "default" {
  name = "infra-prometheus"
}

data "grafana_oncall_label" "severity" {
  key   = "severity"
  value = "{{ payload.commonLabels.severity }}"
}

data "grafana_oncall_label" "network" {
  key   = "project_name"
  value = "{{ payload.commonLabels.network }}"
}

data "grafana_team" "this" {
  name = var.oncall_team
}

data "grafana_oncall_team" "this" {
  name = data.grafana_team.this.name
}

data "grafana_oncall_escalation_chain" "critical" {
  name = "${var.oncall_team}-critical"
}

data "grafana_oncall_escalation_chain" "warning" {
  name = "${var.oncall_team}-warning"
}
