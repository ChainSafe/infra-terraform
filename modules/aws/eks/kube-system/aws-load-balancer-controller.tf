locals {
  alb_ingress_name = "aws-load-balancer-controller"
}

resource "helm_release" "alb_ingress" {
  name       = local.alb_ingress_name
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = var.alb_controller_version

  values = [
    templatefile(
      "${path.module}/values/aws-load-balancer-controller.yaml",
      {
        cluster         = data.aws_eks_cluster.this.name
        region          = var.default_variables.region
        sa_name         = local.alb_ingress_name
        sa_iam_role_arn = aws_iam_role.aws_alb_ingress_controller.arn
      }
    ),
    yamlencode(
      {
        defaultTags = {
          for k, v in var.tags :
          k => v
          if v != null
        }
      }
    )
  ]

  depends_on = [
    aws_iam_role_policy.aws_alb_ingress_controller
  ]
}

data "aws_iam_policy_document" "aws_alb_ingress_controller" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"

      identifiers = [
        "arn:aws:iam::${var.default_variables.account_id}:oidc-provider/${local.oidc_provider_url}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider_url}:sub"
      values = [
        "system:serviceaccount:kube-system:${local.alb_ingress_name}"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider_url}:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "aws_alb_ingress_controller" {
  name = "${data.aws_eks_cluster.this.name}-${local.alb_ingress_name}"

  assume_role_policy = data.aws_iam_policy_document.aws_alb_ingress_controller.json

  tags = merge(
    var.tags,
    {
      Name = "${data.aws_eks_cluster.this.name}-${local.alb_ingress_name}"
    }
  )
}

resource "aws_iam_role_policy" "aws_alb_ingress_controller" {
  role   = aws_iam_role.aws_alb_ingress_controller.id
  name   = "aws-load-balancer-controller"
  policy = file("${path.module}/policies/aws-load-balancer-controller.json")
}
