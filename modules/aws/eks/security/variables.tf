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
