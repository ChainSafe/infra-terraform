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

# https://github.com/bitnami/charts/blob/main/bitnami/keycloak/Chart.yaml
variable "keycloak_version" {
  type = string

  description = <<DESC
Version of keycloak (defaults "25.2.0")

https://github.com/bitnami/charts/blob/main/bitnami/keycloak/Chart.yaml

Example:
keycloak_version = "25.2.0"
DESC

  default = "25.2.0"
}
