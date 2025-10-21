resource "grafana_rule_group" "this" {
  for_each = local.alert_rules

  folder_uid = grafana_folder.this.uid
  name       = each.key

  interval_seconds   = 300 # 5 min
  disable_provenance = true

  dynamic "rule" {
    for_each = each.value

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
      labels = merge(
        rule.value.labels,
        {
          project_name = var.project_name
          network      = "{{ $labels.network }}"
          job : "{{ $labels.job }}"
          instance : "{{ $labels.instance }}"
        }
      )
      annotations = rule.value.annotations

      notification_settings {
        contact_point = grafana_contact_point.this.name
      }
    }
  }
}

resource "grafana_rule_group" "this_v2" {
  for_each = local.alert_rules_v2

  folder_uid = grafana_folder.this.uid
  name       = each.key

  interval_seconds   = 300 # 5 min
  disable_provenance = true

  dynamic "rule" {
    for_each = each.value

    content {
      name = rule.key
      for  = lookup(rule.value, "for", "10m")

      condition      = "C"
      no_data_state  = "OK"
      exec_err_state = "Alerting"

      labels = merge(
        lookup(rule.value, "labels", {}),
        {
          project_name = var.project_name
          network      = "{{ $labels.network }}"
          job          = "{{ $labels.job }}"
          instance     = "{{ $labels.instance }}"
          severity     = <<EOF
{{- if ${rule.value.severities.type} $values.B.Value ${rule.value.severities.critical} -}}Critical
%{~if rule.value.severities.major != null~}
{{- else if ${rule.value.severities.type} $values.B.Value ${rule.value.severities.major} -}}Major
%{~endif}
{{- else if ${rule.value.severities.type} $values.B.Value ${rule.value.severities.warning} -}}Minor
{{- else -}}none
{{- end -}}
EOF
        }
      )
      annotations = lookup(rule.value, "annotations", {})

      data {
        ref_id = "A"
        relative_time_range {
          from = 600
          to   = 0
        }
        datasource_uid = rule.value.datasource_uid
        model = jsonencode({
          refId        = "A"
          expr         = rule.value.expr
          legendFormat = "{{instance}}"
        })
      }

      data {
        ref_id = "B"
        relative_time_range {
          from = 600
          to   = 0
        }
        datasource_uid = "-100"
        model = jsonencode({
          refId      = "B"
          expression = "A"
          type       = "reduce"
          reducer    = "last"
          settings = {
            mode = "dropNN"
          }
        })
      }

      data {
        ref_id = "C"
        relative_time_range {
          from = 600
          to   = 0
        }
        datasource_uid = "-100"
        model = jsonencode({
          refId      = "C"
          expression = "B"
          type       = "threshold"
          conditions = [
            {
              evaluator = {
                type = rule.value.severities.type
                params = [
                  rule.value.severities.warning
                ]
              }
            }
          ]
        })
      }

      notification_settings {
        contact_point = grafana_contact_point.this.name
      }
    }
  }
}
