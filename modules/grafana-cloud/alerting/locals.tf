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
  alert_rules = var.alerts_file != "" ? {
    for v in yamldecode(file(var.alerts_file)).rules :
    v.alert => {
      alert          = v.alert
      expr           = v.expr
      for            = lookup(v, "for", "10m")
      datasource_uid = "grafanacloud-prom"
      is_critical = lookup(
        lookup(
          v, "labels", { severity : "warning" }
        ), "severity", "warning"
      ) == "critical"
      labels      = lookup(v, "labels", {})
      annotations = lookup(v, "annotations", {})
    }
  } : {}
}
