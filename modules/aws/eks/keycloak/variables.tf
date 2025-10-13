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

# https://github.com/codecentric/helm-charts/blob/master/charts/keycloakx/Chart.yaml
variable "keycloak_version" {
  type = string

  description = <<DESC
Version of keycloak (defaults "7.1.4")

https://github.com/codecentric/helm-charts/blob/master/charts/keycloakx/Chart.yaml

Example:
keycloak_version = "7.1.4"
DESC

  default = "7.1.4"
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
