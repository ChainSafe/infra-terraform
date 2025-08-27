# Multiple services are dependent on the prometheus-rules
resource "kubectl_manifest" "crds" {
  for_each = toset([
    "monitoring.coreos.com_prometheusrules",
    "monitoring.coreos.com_servicemonitors",
  ])
  yaml_body = file("${path.module}/manifests/${each.key}.yaml")
}
