data "aws_iam_policy_document" "vault_unseal" {
  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
    ]
    resources = [
      aws_kms_key.vault_unseal.arn
    ]
  }
}

#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "vault_aws_cross_account" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    resources = [
      "arn:aws:iam::*:role/vault-access"
    ]
  }
}

#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "vault_sts_auth" {
  statement {
    actions = [
      "ec2:DescribeInstances",
      "iam:GetInstanceProfile",
      "iam:GetUser",
      "iam:GetRole",
    ]
    resources = ["*"]
  }
}

locals {
  vault_sa  = "vault-server"
  backup_sa = "vault-backup"
}

data "aws_iam_policy_document" "vault_assume_role_with_oidc" {
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
      test     = "ForAnyValue:StringEquals"
      variable = "${local.oidc_provider_url}:sub"
      values = [
        "system:serviceaccount:${kubernetes_namespace.this.metadata[0].name}:${local.vault_sa}",
        "system:serviceaccount:${kubernetes_namespace.this.metadata[0].name}:${local.backup_sa}",
      ]
    }
  }
}

resource "aws_iam_role" "this" {
  name = "${data.aws_eks_cluster.this.name}-vault"

  assume_role_policy = data.aws_iam_policy_document.vault_assume_role_with_oidc.json

  tags = merge(
    var.tags,
    {
      Name = "${data.aws_eks_cluster.this.name}-vault"
    }
  )
}

resource "aws_iam_role_policy" "auto_unseal" {
  role   = aws_iam_role.this.id
  name   = "auto-unseal"
  policy = data.aws_iam_policy_document.vault_unseal.json
}

resource "aws_iam_role_policy" "aws_cross_account" {
  role   = aws_iam_role.this.id
  name   = "aws-cross-account"
  policy = data.aws_iam_policy_document.vault_aws_cross_account.json
}

resource "aws_iam_role_policy" "sts_assume" {
  role   = aws_iam_role.this.id
  name   = "sts-assume"
  policy = data.aws_iam_policy_document.vault_sts_auth.json
}

# Vault Cross account access
data "aws_iam_policy_document" "vault_assume_cross_account" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.this.arn]
    }
  }
}

resource "aws_iam_role" "org_vault" {
  assume_role_policy = data.aws_iam_policy_document.vault_assume_cross_account.json
  name               = "vault-access"
}

resource "aws_iam_role_policy" "org_vault" {
  role   = aws_iam_role.org_vault.id
  name   = "vault-sts-validation"
  policy = data.aws_iam_policy_document.vault_sts_auth.json
}
