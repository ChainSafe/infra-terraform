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

# https://github.com/hashicorp/vault-helm/blob/master/Chart.yaml
variable "vault_version" {
  type = string

  description = <<DESC
Version of hashicorp/vault (defaults "0.30.1")

https://github.com/hashicorp/vault-helm/blob/master/Chart.yaml

Example:
* vault_version = "0.9.0"
DESC

  default = "0.30.1"
}
