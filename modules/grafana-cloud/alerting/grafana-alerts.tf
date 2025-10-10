resource "grafana_rule_group" "this" {
  count = length(var.alerts) > 0 || var.alerts_file != "" ? 1 : 0

  name             = var.default_variables.project
  folder_uid       = grafana_folder.this.uid
  interval_seconds = 300 # 5 min

  dynamic "rule" {
    for_each = var.alerts

    content {
      name      = rule.key
      for       = "${rule.value.duration_minutes}m"
      condition = "A"
      data {
        ref_id = "A"
        relative_time_range {
          from = rule.value.for_minutes * 60
          to   = 0
        }
        datasource_uid = rule.value.datasource_uid
        model = jsonencode({
          hide                = false
          disableTextWrap     = false
          intervalMs          = 1000
          maxDataPoints       = 43200
          expr                = rule.value.expr
          fullMetaSearch      = false
          includeNullMetadata = true
          instant             = true
          range               = false
          refId               = "A"
          legendFormat        = "__auto"
          useBackend          = false
        })
      }
      no_data_state  = "OK"
      exec_err_state = "Alerting"
      labels         = rule.value.labels
      annotations    = rule.value.annotations

      notification_settings {
        contact_point = rule.value.is_critical ? grafana_contact_point.critical.name : grafana_contact_point.warning.name
      }
    }
  }
  dynamic "rule" {
    for_each = local.alert_rules

    content {
      name      = rule.key
      for       = rule.value.for
      condition = "A"
      data {
        ref_id = "A"
        relative_time_range {
          from = 600
          to   = 0
        }
        datasource_uid = rule.value.datasource_uid
        model = jsonencode({
          hide                = false
          disableTextWrap     = false
          intervalMs          = 1000
          maxDataPoints       = 43200
          expr                = rule.value.expr
          fullMetaSearch      = false
          includeNullMetadata = true
          instant             = true
          range               = false
          refId               = "A"
          legendFormat        = "__auto"
          useBackend          = false
        })
      }
      no_data_state  = "OK"
      exec_err_state = "Alerting"
      labels         = rule.value.labels
      annotations    = rule.value.annotations

      notification_settings {
        contact_point = rule.value.is_critical ? grafana_contact_point.critical.name : grafana_contact_point.warning.name
      }
    }
  }
}
