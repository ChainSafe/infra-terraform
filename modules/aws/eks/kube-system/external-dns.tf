locals {
  external_dns_name = "external-dns"
}

resource "kubernetes_namespace_v1" "external_dns" {
  metadata {
    name = "external-dns"
  }
}

resource "helm_release" "external_dns" {
  name       = "${local.external_dns_name}-public"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  namespace  = kubernetes_namespace_v1.external_dns.metadata[0].name
  version    = var.external_dns_version

  values = [
    templatefile(
      "${path.module}/values/external-dns.yaml",
      {
        sa_name    = "${local.external_dns_name}-public"
        iam_role   = aws_iam_role.external_dns.arn
        provider   = "aws"
        aws_region = var.default_variables.region
        cluster    = data.aws_eks_cluster.this.name
        include_zones = [
          data.aws_route53_zone.public.zone_id
        ]
        zone_type      = "public"
        dynamodb_table = aws_dynamodb_table.external_dns.name
      }
    ),
  ]

  set_list = [{
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
  ]

  depends_on = [
    aws_iam_role_policy.external_dns,
    aws_iam_role_policy_attachment.external_dns
  ]
}

resource "aws_dynamodb_table" "external_dns" {
  name = "${data.aws_eks_cluster.this.name}-${local.external_dns_name}"

  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5

  hash_key = "k"

  attribute {
    name = "k"
    type = "S"
  }

  tags = merge(
    var.tags,
    {
      Name = "${data.aws_eks_cluster.this.name}-${local.external_dns_name}"
    }
  )
}

data "aws_iam_policy_document" "assume_external_dns" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
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
        "system:serviceaccount:${kubernetes_namespace_v1.external_dns.metadata[0].name}:${local.external_dns_name}-public"
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

data "aws_iam_policy_document" "external_dns" {
  statement {
    effect = "Allow"
    actions = [
      "route53:ChangeResourceRecordSets"
    ]
    resources = [
      data.aws_route53_zone.public.arn,
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "DynamoDB:DescribeTable",
      "DynamoDB:PartiQLDelete",
      "DynamoDB:PartiQLInsert",
      "DynamoDB:PartiQLUpdate",
      "DynamoDB:Scan"
    ]
    resources = [
      aws_dynamodb_table.external_dns.arn
    ]
  }
}

resource "aws_iam_role" "external_dns" {
  name               = "${data.aws_eks_cluster.this.name}-${local.external_dns_name}-public"
  assume_role_policy = data.aws_iam_policy_document.assume_external_dns.json

  tags = merge(
    var.tags,
    {
      Name = "${data.aws_eks_cluster.this.name}-${local.external_dns_name}-public"
    }
  )
}

resource "aws_iam_role_policy" "external_dns" {
  role   = aws_iam_role.external_dns.id
  name   = "external-dns-permissions"
  policy = data.aws_iam_policy_document.external_dns.json
}

resource "aws_iam_role_policy_attachment" "external_dns" {
  role       = aws_iam_role.external_dns.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53ReadOnlyAccess"
}
