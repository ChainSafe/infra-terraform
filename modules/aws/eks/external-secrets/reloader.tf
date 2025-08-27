resource "helm_release" "reloader" {
  name       = "reloader"
  chart      = "reloader"
  version    = var.secrets_reloader_version
  repository = "https://stakater.github.io/stakater-charts"

  namespace = local.namespace

  values = [
    <<DESC
reloader:
  ignoreConfigMaps: true
  isArgoRollouts: true
  reloadStrategy: annotations
  # resourceLabelSelector: external-secret=true
  resources:
    limits:
      cpu: 200m
      memory: 256Mi
    requests:
      cpu: 200m
      memory: 256Mi
  deployment:
    nodeSelector:
      dedicated: managed
    tolerations:
    - key: CriticalAddonsOnly
      operator: Exists
DESC
  ]
}
