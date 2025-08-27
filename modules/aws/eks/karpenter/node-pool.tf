resource "kubectl_manifest" "karpenter_node_pool" {
  for_each = var.node_groups

  yaml_body = templatefile(
    "${path.module}/templates/node-pool.yaml",
    {
      name            = each.key
      node_class      = each.value.class
      instance_family = each.value.family
      instance_cpu    = each.value.cpu
      hypervisor      = each.value.hypervisor
      capacity_type   = each.value.is_spot ? "spot" : "on-demand"
      cpu_limit       = each.value.max_cpu
      memory_limit    = each.value.max_cpu * 4
    }
  )

  depends_on = [
    helm_release.karpenter
  ]
}
