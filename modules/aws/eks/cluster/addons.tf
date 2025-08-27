locals {
  cluster_addons = {
    eks-pod-identity-agent = {
      before_compute = true
      most_recent    = true
    }
    kube-proxy = {
      before_compute = true
      most_recent    = true
    }
    vpc-cni = {
      before_compute              = true
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      service_account_role_arn    = aws_iam_role.vpc_cni_irsa.arn
      configuration_values = jsonencode(
        {
          enableNetworkPolicy = "true"
        }
      )
    }

    coredns = {
      most_recent = true
      configuration_values = jsonencode({
        autoScaling = {
          enabled     = true
          minReplicas = 2
          maxReplicas = 10
        }
        corefile = <<CONF
.:53 {
    errors
    health {
      lameduck 5s
    }
    ready
    kubernetes cluster.local in-addr.arpa ip6.arpa {
      pods insecure
      fallthrough in-addr.arpa ip6.arpa
      ttl 30
    }
    prometheus :9153
    forward . "/etc/resolv.conf"
    cache 30
    loop
    reload
    loadbalance
}
CONF
      })
    }
    aws-ebs-csi-driver = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      service_account_role_arn    = aws_iam_role.ebs_csi_irsa.arn
      configuration_values = jsonencode({
        controller = {
          extraVolumeTags = merge(
            local.global_tags,
            var.tags,
          )
          loggingFormat = "json"
        }
        node = {
          loggingFormat = "json"
        }
      })
    }
    aws-efs-csi-driver = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      service_account_role_arn    = aws_iam_role.efs_csi_irsa.arn
    }
    metrics-server = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      configuration_values = jsonencode({
        nodeSelector = {
          nodegroup = "default"
        }
        tolerations = [
          {
            key      = "CriticalAddonsOnly"
            operator = "Exists"
          }
        ]
      })
    }
  }
}
