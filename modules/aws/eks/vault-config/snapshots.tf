locals {
  kubernetes_namespace = "vault"
  s3_backup_bucket     = lower("${var.default_variables.organization}-${data.aws_eks_cluster.this.name}-vault-backups")
}

resource "kubernetes_service_account" "backup" {
  metadata {
    name      = "vault-backup"
    namespace = local.kubernetes_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = data.aws_iam_role.backup.arn
    }
  }
}

resource "vault_policy" "backup" {
  name   = "vault-backup"
  policy = <<HCL
path "sys/storage/raft/snapshot" {
  capabilities = ["read"]
}
HCL
}

resource "vault_kubernetes_auth_backend_role" "backup" {
  backend   = vault_auth_backend.kubernetes.path
  role_name = "vault-backup"

  bound_service_account_names = [
    kubernetes_service_account.backup.metadata[0].name
  ]
  bound_service_account_namespaces = [
    local.kubernetes_namespace
  ]

  token_policies = [
    vault_policy.backup.name
  ]
  token_ttl = 600
}

resource "kubernetes_cron_job_v1" "this" {
  metadata {
    name      = "vault-snapshot-cronjob"
    namespace = local.kubernetes_namespace
  }
  spec {
    schedule           = "@every 12h"
    concurrency_policy = "Forbid"
    job_template {
      metadata {}
      spec {
        template {
          metadata {
            annotations = {
              "vault.hashicorp.com/agent-inject"            = "true"
              "vault.hashicorp.com/agent-pre-populate-only" = "true"
              "vault.hashicorp.com/auth-path" : "auth/${vault_auth_backend.kubernetes.path}"
              "vault.hashicorp.com/role" : vault_kubernetes_auth_backend_role.backup.role_name
              "vault.hashicorp.com/agent-inject-token" = "true"
            }
          }
          spec {
            service_account_name = kubernetes_service_account.backup.metadata[0].name
            restart_policy       = "OnFailure"
            node_selector = {
              nodegroup = "default"
            }
            toleration {
              key      = "nodegroup"
              operator = "Equal"
              value    = "default"
              effect   = "NoSchedule"
            }
            volume {
              name = "share"
              empty_dir {}
            }
            container {
              name    = "snapshot"
              image   = "hashicorp/vault:1.20.1"
              command = ["/bin/sh"]
              args = [
                "-ec",
                "VAULT_TOKEN=$(cat /vault/secrets/token) vault operator raft snapshot save /share/vault-raft.snap"
              ]
              env {
                name  = "VAULT_ADDR"
                value = "http://vault-server-active:8200"
              }
              volume_mount {
                name       = "share"
                mount_path = "/share"
              }
            }
            container {
              name    = "upload"
              image   = "amazon/aws-cli:latest"
              command = ["/bin/sh"]
              args = [
                "-ec",
                <<-ARG
                  until [ -f /share/vault-raft.snap ]; do sleep 5; done;
                  aws s3 cp /share/vault-raft.snap s3://${aws_s3_bucket.backup.bucket}/vault_raft_$(date +"%Y%m%d_%H%M%S").snapshot;
                ARG
              ]
              volume_mount {
                name       = "share"
                mount_path = "/share"
              }
            }
          }
        }
      }
    }
  }
}

#tfsec:ignore:aws-s3-block-public-acls tfsec:ignore:aws-s3-block-public-policy tfsec:ignore:aws-s3-ignore-public-acls tfsec:ignore:aws-s3-no-public-buckets tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "backup" {
  bucket = local.s3_backup_bucket

  tags = merge(
    var.tags,
    {
      Name = local.s3_backup_bucket
    }
  )
}

resource "aws_s3_bucket_versioning" "backup" {
  bucket = aws_s3_bucket.backup.id

  versioning_configuration {
    status = "Disabled"
  }
}

#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "backup" {
  bucket = aws_s3_bucket.backup.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "backup" {
  bucket = aws_s3_bucket.backup.id

  rule {
    id     = "cleanup"
    status = "Enabled"

    expiration {
      days = 30
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.backup.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = data.aws_iam_role.backup.arn
        }
        Action = "s3:*"
        Resource = [
          aws_s3_bucket.backup.arn,
          "${aws_s3_bucket.backup.arn}/*",
        ]
      },
    ]
  })
}
