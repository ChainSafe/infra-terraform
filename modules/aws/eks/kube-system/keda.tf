locals {
  keda_sa = "keda-operator-sa"
  keda_ns = "keda"
}
resource "helm_release" "keda" {
  name             = "keda"
  repository       = "https://kedacore.github.io/charts"
  chart            = "keda"
  namespace        = local.keda_ns
  create_namespace = true
  version          = var.keda_version

  values = [
    <<EOT
clusterName: ${local.eks_cluster_name}
crds:
  install: true
nodeSelector:
  nodegroup: default
tolerations:
  - key: CriticalAddonsOnly
    operator: Exists
serviceAccount:
  operator:
    create: true
    name: ${local.keda_sa}
EOT
  ]
}

resource "aws_eks_pod_identity_association" "keda" {
  cluster_name = data.aws_eks_cluster.this.name
  role_arn     = aws_iam_role.keda.arn

  namespace       = local.keda_ns
  service_account = local.keda_sa

  depends_on = [
    helm_release.keda,
    aws_iam_role_policy.keda
  ]
}

data "aws_iam_policy_document" "assume_keda" {
  statement {
    sid    = "AllowEksAuthToAssumeRoleForPodIdentity"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]
  }
}

resource "aws_iam_role" "keda" {
  name                  = "${local.eks_cluster_name}-keda"
  assume_role_policy    = data.aws_iam_policy_document.assume_keda.json
  force_detach_policies = true

  tags = merge(
    var.tags,
    {
      Name = "${local.eks_cluster_name}-keda"
    }
  )
}

data "aws_iam_policy_document" "keda" {
  statement {
    actions   = ["sqs:GetQueueAttributes"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      values   = ["ApproximateNumberOfMessages"]
      variable = "sqs:AttributeName"
    }
  }
}

resource "aws_iam_role_policy" "keda" {
  role   = aws_iam_role.keda.id
  policy = data.aws_iam_policy_document.keda.json
}
