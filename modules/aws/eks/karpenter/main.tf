# noinspection TfUnknownProperty
module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "~> v21.0"

  cluster_name         = local.eks_cluster_name
  queue_name           = "${local.eks_cluster_name}-karpenter"
  create_node_iam_role = false
  node_iam_role_arn    = data.aws_iam_role.eks_node.arn
  # Since the node group role will already have an access entry
  create_access_entry = false

  create_pod_identity_association = true
}

resource "helm_release" "karpenter_crds" {
  name      = "karpenter-crd"
  namespace = "kube-system"

  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter-crd"
  version    = var.karpenter_version
}

resource "helm_release" "karpenter" {
  name      = "karpenter"
  namespace = "kube-system"

  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter"
  version    = var.karpenter_version
  skip_crds  = true
  wait       = false

  values = [
    <<-EOT
    serviceAccount:
      name: ${module.karpenter.service_account}
    settings:
      clusterName: ${local.eks_cluster_name}
      clusterEndpoint: ${data.aws_eks_cluster.this.endpoint}
      interruptionQueue: ${module.karpenter.queue_name}
    EOT
  ]
  depends_on = [
    helm_release.karpenter_crds,
    module.karpenter
  ]
}

resource "aws_iam_service_linked_role" "spots" {
  aws_service_name = "spot.amazonaws.com"
}
