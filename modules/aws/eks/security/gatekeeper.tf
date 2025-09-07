locals {
  excluded_ns = setunion(
    [
      "actions-runner-controller",
      "actions-runners",
      "argocd",
      "atlantis",
      "calico-system",
      "cert-manager",
      "external-dns",
      "external-secrets",
      "grafana",
      "harbor",
      "ingress-nginx",
      "keda",
      "kube-system",
      "kubecost",
      "loki",
      "metrics-server",
      "monitoring",
      "nexus",
      "security",
      "vault",
    ],
    var.gatekeeper_exclude_ns
  )

  gatekeeper_templates = {
    for file_name in fileset("${path.module}/policies/gatekeeper/templates", "*.yaml") :
    file_name => "${path.module}/policies/gatekeeper/templates/${file_name}"
  }
  gatekeeper_constraints = {
    for file_name in fileset("${path.module}/policies/gatekeeper/constraints", "*.yaml") :
    file_name => "${path.module}/policies/gatekeeper/constraints/${file_name}"
  }
}

resource "helm_release" "gatekeeper" {
  name       = "gatekeeper"
  repository = "https://open-policy-agent.github.io/gatekeeper/charts"
  chart      = "gatekeeper"
  namespace  = local.namespace
  version    = var.gatekeeper_version

  values = [
    file("${path.module}/values/gatekeeper.yaml")
  ]
}

resource "random_uuid" "gatekeeper_ui" {}

resource "helm_release" "gatekeeper_ui" {
  name       = "gatekeeper-ui"
  repository = "https://sighupio.github.io/gatekeeper-policy-manager"
  chart      = "gatekeeper-policy-manager"
  namespace  = local.namespace

  set_sensitive = [
    {
      name  = "config.secretKey"
      value = random_uuid.gatekeeper_ui.result
    }
  ]
}

resource "kubectl_manifest" "gatekeeper_config" {
  yaml_body = yamlencode(
    merge(
      yamldecode(
        file("${path.module}/policies/gatekeeper/config.yaml")
      ),
      {
        spec = {
          match = [
            {
              excludedNamespaces = local.excluded_ns
              processes          = ["*"]
            }
          ]
        }
      }
    )
  )

  depends_on = [
    helm_release.gatekeeper
  ]
}

resource "kubectl_manifest" "gatekeeper_templates" {
  for_each = local.gatekeeper_templates

  yaml_body = file(each.value)

  depends_on = [
    kubectl_manifest.gatekeeper_config
  ]
}

resource "kubectl_manifest" "gatekeeper_constraints" {
  for_each = local.gatekeeper_constraints

  yaml_body = yamlencode(
    merge(
      yamldecode(
        file(each.value)
      ),
      {
        spec = {
          match = {
            excludedNamespaces = local.excluded_ns
          }
        }
      }
    )
  )

  depends_on = [
    kubectl_manifest.gatekeeper_templates
  ]
}
