locals {
  external_dns_name = "external-dns"
}

resource "kubernetes_namespace_v1" "external_dns" {
  metadata {
    name = "external-dns"
  }
}

resource "kubernetes_secret_v1" "external_dns" {
  metadata {
    name      = "cloudflare-access"
    namespace = kubernetes_namespace_v1.external_dns.metadata[0].name
  }
  data = {
    cloudflare_api_token = ""
  }
}

resource "helm_release" "external_dns" {
  count      = var.enable_public_external_dns ? 1 : 0
  name       = "${local.external_dns_name}-public"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "external-dns"
  namespace  = kubernetes_namespace_v1.external_dns.metadata[0].name
  version    = var.external_dns_version

  values = [
    templatefile(
      "${path.module}/values/external-dns.yaml",
      {
        annotation_filter = "alb.ingress.kubernetes.io/scheme in (internet-facing)"
        cluster           = data.aws_eks_cluster.this.name
        cf_secret_name    = "" #???
        include_domains   = "" #???
        # include_zones = compact([
        #   data.aws_route53_zone.public.zone_id,
        #   local.external_dns_global ? data.aws_route53_zone.global_public[0].zone_id : ""
        # ])
      }
    ),
  ]

  set_list {
    name = "sources"
    value = compact([
      "service",
      "ingress",
      contains(data.kubernetes_all_namespaces.this.namespaces, "istio-system") ? "istio-gateway" : "",
      contains(data.kubernetes_all_namespaces.this.namespaces, "istio-system") ? "istio-virtualservice" : "",
      contains(data.kubernetes_all_namespaces.this.namespaces, "kong") ? "gateway-httproute" : "",
      contains(data.kubernetes_all_namespaces.this.namespaces, "kong") ? "gateway-grpcroute" : "",
    ])
  }

  # depends_on = [
  #   aws_iam_role_policy.external_dns,
  #   aws_iam_role_policy_attachment.external_dns
  # ]
}

# resource "aws_dynamodb_table" "external_dns" {
#   name = "${data.aws_eks_cluster.this.name}-${local.external_dns_name}"
#
#   billing_mode   = "PROVISIONED"
#   read_capacity  = 5
#   write_capacity = 5
#
#   hash_key = "k"
#   attribute {
#     name = "k"
#     type = "S"
#   }
#
#   tags = merge(
#     var.tags,
#     {
#       Name = "${data.aws_eks_cluster.this.name}-${local.external_dns_name}"
#     }
#   )
# }
#
# data "aws_iam_policy_document" "assume_external_dns" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "sts:AssumeRoleWithWebIdentity"
#     ]
#     principals {
#       type = "Federated"
#       identifiers = [
#         "arn:aws:iam::${var.default_variables.account_id}:oidc-provider/${local.oidc_provider_url}"
#       ]
#     }
#
#     condition {
#       test     = "StringEquals"
#       variable = "${local.oidc_provider_url}:sub"
#       values = [
#         "system:serviceaccount:${kubernetes_namespace_v1.external_dns.metadata[0].name}:${local.external_dns_name}-public"
#       ]
#     }
#     condition {
#       test     = "StringEquals"
#       variable = "${local.oidc_provider_url}:aud"
#       values = [
#         "sts.amazonaws.com"
#       ]
#     }
#   }
# }
#
# data "aws_iam_policy_document" "external_dns" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "DynamoDB:DescribeTable",
#       "DynamoDB:PartiQLDelete",
#       "DynamoDB:PartiQLInsert",
#       "DynamoDB:PartiQLUpdate",
#       "DynamoDB:Scan"
#     ]
#     resources = [
#       aws_dynamodb_table.external_dns.arn
#     ]
#   }
# }
#
# resource "aws_iam_role" "external_dns" {
#   count = var.enable_public_external_dns ? 1 : 0
#
#   name               = "${data.aws_eks_cluster.this.name}-${local.external_dns_name}-public"
#   assume_role_policy = data.aws_iam_policy_document.assume_external_dns.json
#
#   tags = merge(
#     var.tags,
#     {
#       Name = "${data.aws_eks_cluster.this.name}-${local.external_dns_name}-public"
#     }
#   )
# }
#
# resource "aws_iam_role_policy" "external_dns" {
#   count = var.enable_public_external_dns ? 1 : 0
#
#   role   = aws_iam_role.external_dns[0].id
#   name   = "external-dns-permissions"
#   policy = data.aws_iam_policy_document.external_dns.json
# }
#
# resource "aws_iam_role_policy_attachment" "external_dns" {
#   count = var.enable_public_external_dns ? 1 : 0
#
#   role       = aws_iam_role.external_dns[0].id
#   policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53ReadOnlyAccess"
# }
