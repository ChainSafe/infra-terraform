resource "grafana_dashboard" "this" {
  for_each = var.dashboards

  config_json = file("${path.module}/${each.key}")
  folder      = grafana_folder.this.id
  overwrite   = true
}
