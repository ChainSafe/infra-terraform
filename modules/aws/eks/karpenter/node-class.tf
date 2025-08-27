resource "kubectl_manifest" "karpenter_node_class" {
  for_each = toset([
    "bottlerocket",
    "al2023"
  ])
  yaml_body = templatefile(
    "${path.module}/templates/node-class/${each.key}.yaml",
    {
      cluster_name       = local.eks_cluster_name
      node_iam_role_name = data.aws_iam_role.eks_node.name
      tags = merge(
        local.global_tags,
        var.tags,
        {
          Name         = "${var.cluster_name}-karpenter-${each.key}"
          component_id = "platform_node"
        }
      )
    }
  )

  depends_on = [
    helm_release.karpenter
  ]
}
