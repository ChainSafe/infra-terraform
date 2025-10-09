resource "grafana_synthetic_monitoring_check" "this" {
  for_each = var.k6_checks

  job    = each.key
  target = each.value.url
  probes = [
    for probe in each.value.probes :
    data.grafana_synthetic_monitoring_probes.this.probes[probe]
  ]

  settings {
    dynamic "http" {
      for_each = each.value.type == "http" ? [1] : []
      content {
        method             = each.value.method
        body               = each.value.body
        valid_status_codes = each.value.status_code
      }
    }

    dynamic "scripted" {
      for_each = each.value.type == "scripted" ? [1] : []
      content {
        script = file(each.value.script)
      }
    }
  }
}
