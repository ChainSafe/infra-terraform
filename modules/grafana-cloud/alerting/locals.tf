locals {
  time_zone = "Europe/Berlin"

  dashboards = {
    for dashboard_file in var.dashboards :
    dashboard_file => {
      for k, v in jsondecode(file(dashboard_file)) :
      k => v
      if !contains(["id", "uid", "version", "iteration", "gnetId"], k)
    }
  }

  # noinspection HILUnresolvedReference
  alert_rules_files = var.alerts_files != {} ? {
    for rule_group, config in var.alerts_files :
    rule_group => {
      for v in yamldecode(file(config)).rules :
      v.alert => {
        alert          = v.alert
        expr           = v.expr
        for            = lookup(v, "for", "10m")
        datasource_uid = lookup(yamldecode(file(config)), "datasource", data.grafana_data_source.default.uid)
        is_critical = lookup(
          lookup(
            v, "labels", { severity : "Minor" }
          ), "severity", "Minor"
        ) == "Critical"
        labels      = lookup(v, "labels", {})
        annotations = lookup(v, "annotations", {})
      }
    }
  } : {}

  alert_rules_v2 = var.alerts_v2 != {} ? {
    for rule_group, config in var.alerts_v2 :
    rule_group => {
      for v in yamldecode(file(config)).rules :
      v.alert => {
        alert          = v.alert
        expr           = v.expr
        for            = lookup(v, "for", "10m")
        datasource_uid = lookup(yamldecode(file(config)), "datasource", data.grafana_data_source.default.uid)
        severities = {
          type     = v.severities.type
          warning  = v.severities.warning
          critical = v.severities.critical
          major    = lookup(v.severities, "major", null)

        }
        labels      = lookup(v, "labels", {})
        annotations = lookup(v, "annotations", {})
      }
    }
  } : {}

  alert_rules = merge(
    local.alert_rules_files,
    var.alerts
  )
}
