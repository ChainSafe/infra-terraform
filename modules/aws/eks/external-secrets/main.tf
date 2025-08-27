resource "kubernetes_namespace" "external_secrets" {
  metadata {
    name = "external-secrets"
  }
}

locals {
  namespace = kubernetes_namespace.external_secrets.metadata[0].name
}

resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  chart      = "external-secrets"
  version    = var.external_secrets_version
  repository = "https://charts.external-secrets.io/"

  namespace = local.namespace

  values = [
    <<DESC
global:
  nodeSelector:
    dedicated: managed
  tolerations:
  - key: CriticalAddonsOnly
    operator: Exists
processClusterExternalSecret: false
processPushSecret: false
concurrent: 20
serviceAccount:
  name: "${local.external_secrets_sa}"
serviceMonitor:
  enabled: true
DESC
  ]
}
