resource "grafana_contact_point" "this" {
  name               = "${var.project_name}-incidents"
  disable_provenance = true

  oncall {
    url = grafana_oncall_integration.this.link
  }
}

resource "grafana_oncall_integration" "this" {
  name = var.project_name
  type = "grafana_alerting"

  team_id = data.grafana_oncall_team.this.id

  dynamic_labels = [
    data.grafana_oncall_label.severity,
    data.grafana_oncall_label.network,
  ]

  default_route {
    escalation_chain_id = data.grafana_oncall_escalation_chain.warning.id
  }
}

resource "grafana_oncall_route" "critical" {
  integration_id      = grafana_oncall_integration.this.id
  escalation_chain_id = data.grafana_oncall_escalation_chain.critical.id
  routing_type        = "jinja2"
  routing_regex       = "{{ payload.severity == \"Critical\" }}"
  position            = 0
}
