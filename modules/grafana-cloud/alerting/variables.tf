variable "project_name" {
  type = string

  description = <<DESC
Name of the Grafana project

Example:
* project_name = "example"
DESC
}

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

variable "oncall_team" {
  type = string

  description = <<DESC
Name of the on-call team (defaults "devops")

Example:
* oncall_team = "api"
DESC

  default = "devops"
}

variable "alerts" {
  type = map(
    map(
      object({
        expr             = string
        duration_minutes = optional(number, 10)
        datasource_uid   = optional(string, "grafanacloud-prom")
        is_critical      = optional(bool, false)
        labels           = optional(map(string), {})
        annotations      = optional(map(string), {})
      })
    )
  )

  description = <<DESC
Configuration of Grafana Cloud Alert rules (defaults {})

Example:
* alerts = {
  "filecoin-snapshot" = {
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
}
DESC

  default = {}
}

variable "alerts_files" {
  type = map(string)

  description = <<DESC
Prometheus/Alertmanager rules files (defaults {})

If provided alert rules would be generated from the file

Example:
* alerts_files = {
  "filecoin-snapshot" = "./alerts/filecoin-snapshot.yaml"
}
DESC
  default     = {}
}

variable "alerts_v2" {
  type = map(string)

  description = <<DESC
Grafana rules files (defaults {})

If provided alert rules would be generated from the file

Example:
* alerts_v2 = {
  "filecoin-snapshot" = "./alerts-v2/filecoin-snapshot.yaml"
}
DESC
  default     = {}
}

variable "k6_checks" {
  type = map(
    object(
      {
        type   = string
        url    = string
        probes = set(string)

        # HTTP
        method      = optional(string, "GET")
        body        = optional(string, null)
        status_code = optional(set(number), null)

        # Scripted
        script = optional(string, "")
      }
    )
  )

  description = <<DESC
Map of k6 checks (defaults {})

Example:
* k6_checks = {
  "http_check" = {
    type = "http"
    url = "https://example.com"
    probes = ["London", "Paris"]

    method = "POST"
    status_code = [200, 302]
  }
  "scripted" = {
    type = "scripted"
    url = "https://example.com"
    probes = ["London", "Paris"]

    script = file("./scripts/scripted.js")
  }
}
DESC

  default = {}
}
