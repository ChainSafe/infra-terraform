resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = "security"
    annotations = {
      "admission.gatekeeper.sh/ignore" = "no-self-managing"
    }
    labels = {
      "admission.gatekeeper.sh/ignore" = "no-self-managing"
    }
  }
}

locals {
  namespace = kubernetes_namespace_v1.this.metadata[0].name
}
