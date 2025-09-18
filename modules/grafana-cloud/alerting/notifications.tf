# Something is trending toward a problem or needs investigation.
# High disk usage, approaching quota, latency increasing.
# A single service component failed but there is redundancy.
resource "grafana_contact_point" "warning" {
  name = "${var.default_variables.project}-warning"

  pagerduty {
    group           = var.default_variables.project
    integration_key = pagerduty_service_integration.warning.integration_key
    severity        = "warning"
  }
}

# Something is actively broken or service-impacting.
# Site outage, database down, major error rate spike.
resource "grafana_contact_point" "critical" {
  name = "${var.default_variables.project}-critical"

  pagerduty {
    group           = var.default_variables.project
    integration_key = pagerduty_service_integration.critical.integration_key
    severity        = "critical"
  }
}
