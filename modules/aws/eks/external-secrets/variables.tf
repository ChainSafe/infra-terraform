variable "eks_cluster_name" {
  type        = string
  description = <<DESC
Name of the EKS cluster

If not provided will use account name

Example:
* eks_cluster_name = "dev"
DESC
  default     = ""
}

# https://github.com/external-secrets/external-secrets/blob/main/deploy/charts/external-secrets/Chart.yaml
variable "external_secrets_version" {
  type        = string
  description = <<DESC
Version of external-secrets/external-secrets chart (defaults "0.15.0")

https://github.com/external-secrets/external-secrets/blob/main/deploy/charts/external-secrets/Chart.yaml

Example:
* external_secrets_version = "0.9.0"
DESC
  default     = "0.15.0"
}

# https://github.com/stakater/Reloader/blob/master/deployments/kubernetes/chart/reloader/Chart.yaml
variable "secrets_reloader_version" {
  type        = string
  description = <<DESC
Version of stakater/reloader chart (defaults "2.0.0")

https://github.com/stakater/Reloader/blob/master/deployments/kubernetes/chart/reloader/Chart.yaml

Example:
* secrets_reloader_version = "1.2.2"
DESC
  default     = "2.0.0"
}
