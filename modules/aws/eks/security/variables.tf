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

# https://github.com/open-policy-agent/gatekeeper/blob/master/charts/gatekeeper/Chart.yaml
variable "gatekeeper_version" {
  type        = string
  description = <<DESC
Version of gatekeeper/gatekeeper (defaults "3.20.1")

https://github.com/open-policy-agent/gatekeeper/blob/master/charts/gatekeeper/Chart.yaml

Example:
* gatekeeper_version = "0.1.12"
DESC
  default     = "3.20.1"
}

variable "gatekeeper_exclude_ns" {
  type        = set(string)
  description = <<DESC
Extra namespaces to exclude from gatekeeper (defaults [])

Example:
*
DESC
  default     = []
}

# https://github.com/oauth2-proxy/manifests/blob/main/helm/oauth2-proxy/Chart.yaml
variable "oath2_proxy_version" {
  type        = string
  description = <<DESC
Version of oauth2-proxy (defaults "8.2.0")

https://github.com/oauth2-proxy/manifests/blob/main/helm/oauth2-proxy/Chart.yaml

Example:
* oath2_proxy_version = "8.1.0"
DESC
  default     = "8.2.0"
}

# https://github.com/dexidp/helm-charts/blob/master/charts/dex/Chart.yaml
variable "dex_version" {
  type = string

  description = <<DESC
Version of dex (defaults "0.24.0")

https://github.com/dexidp/helm-charts/blob/master/charts/dex/Chart.yaml

Example:
* dex_version = "8.1.0"
DESC

  default = "0.24.0"

}
