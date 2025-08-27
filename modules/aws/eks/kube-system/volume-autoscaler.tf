# resource "helm_release" "volume_autoscaler" {
#   name      = "volume-autoscaler"
#   chart     = "https://github.com/DevOps-Nirvana/Kubernetes-Volume-Autoscaler/releases/download/${var.volume_autoscaler_version}/volume-autoscaler-helm-chart-${var.volume_autoscaler_version}.tgz"
#   namespace = "kube-system"
#
#   values = [
#     <<EOF
# prometheus_url: "http://kube-prometheus-stack-prometheus.monitoring.svc.cluster.local:9090"
# slack_channel: platform-notifications
# prometheus_label_match: 'namespace=~"(argocd|cert-manager|external-dns|external-secrets|ingress-nginx|keda|kube-system|metrics-server|monitoring|security)"'
#
# nodeSelector:
#  nodegroup: default
# tolerations:
#   - key: CriticalAddonsOnly
#     operator: Exists
# EOF
#   ]
#
#   set_sensitive {
#     name  = "slack_webhook_url"
#     value = data.vault_kv_secret_v2.notifications.data["platform_notificaitons"]
#   }
# }
