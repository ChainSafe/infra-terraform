variable "cluster_name" {
  type        = string
  description = <<DESC
Name of the EKS cluster

If not provided will use account name

Example:
* cluster_name = "dev"
DESC
  default     = ""
}

# https://github.com/ansible-community/awx-operator-helm/blob/main/charts/awx-operator/Chart.yaml
variable "awx_operator_version" {
  type = string

  description = <<DESC
Version of awx-operator (defaults "3.2.0")

https://github.com/ansible-community/awx-operator-helm/blob/main/charts/awx-operator/Chart.yaml

Example:
awx_operator_version = "3.0.0"
DESC

  default = "3.2.0"
}

# https://github.com/lib42/charts/blob/main/charts/ara/Chart.yaml
variable "ara_version" {
  type = string

  description = <<DESC
Version of ara (defaults "0.4.6)

https://github.com/lib42/charts/blob/main/charts/ara/Chart.yaml

Example:
* ara_version = "0.4.0"
DESC

  default = "0.4.6"
}
