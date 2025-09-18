variable "dashboards" {
  type = set(string)

  description = <<DESC
List of files local to the project with dashboards (defaults [])

Example:
* dashboards = [
  "./dashboards/example.json"
]
DESC

  default = []
}

variable "alerts" {
  type = map(
    object({
      expr             = string
      duration_minutes = optional(number, 10)
      datasource_uid   = optional(string, "grafanacloud-prom")
      is_critical      = optional(bool, false)
      labels           = optional(map(string), {})
      annotations      = optional(map(string), {})
    })
  )

  description = <<DESC
Configuration of Grafana Cloud Alert rules (defaults {})

Example:
* alerts = {
  "FilecoinSnapshotAgeOld" = {
    expr = "probe_snapshot_age_minutes > 240"
    for_duration = "5m"
    datasource_uid = "grafanacloud-prom"
    is_critical = true
    labels = {}
    annotations = {
      description = "The Latest Filecoin {{ $labels.network }} Snapshot is older than 120 minutes (2 hours), current age is {{ $values.A.Value }} minutes."
      summary     = "The Latest Filecoin Snapshot is older Than 120 minutes"
    }
  }
}
DESC

  default = {}
}

variable "alerts_file" {
  type = string

  description = <<DESC
Prometheus/Alertmanager rules file (defaults "")

If provided alert rules would be generated from the file

Example:
* alerts_file = "./alerts.yaml"
DESC
  default     = ""
}


variable "pd_escalation_policy" {
  type = string

  description = <<DESC
Name of default PagerDuty escalation policy

Example:
* pd_escalation_policy = "test"
DESC
}
