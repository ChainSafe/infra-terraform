resource "pagerduty_service" "critical" {
  name              = "${var.default_variables.project}-infra-critical"
  escalation_policy = data.pagerduty_escalation_policy.this.id

  incident_urgency_rule {
    type    = "constant"
    urgency = "high"
  }
}

resource "pagerduty_service" "warning" {
  name              = "${var.default_variables.project}-infra-warning"
  escalation_policy = data.pagerduty_escalation_policy.this.id

  incident_urgency_rule {
    type = "use_support_hours"

    during_support_hours {
      type    = "constant"
      urgency = "high"
    }

    outside_support_hours {
      type    = "constant"
      urgency = "low"
    }
  }

  support_hours {
    type         = "fixed_time_per_day"
    time_zone    = local.time_zone
    start_time   = "09:00:00"
    end_time     = "18:00:00"
    days_of_week = [1, 2, 3, 4, 5]
  }
}

resource "pagerduty_service_integration" "critical" {
  name    = "API V2"
  type    = "events_api_v2_inbound_integration"
  service = pagerduty_service.critical.id
}

resource "pagerduty_service_integration" "warning" {
  name    = "API V2"
  type    = "events_api_v2_inbound_integration"
  service = pagerduty_service.warning.id
}
