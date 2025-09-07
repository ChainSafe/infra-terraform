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

# https://github.com/aws/eks-charts/tree/master/stable/aws-load-balancer-controller/Chart.yaml
variable "alb_controller_version" {
  type        = string
  description = <<DESC
Version of eks/aws-load-balancer-controller (defaults "1.13.4")

https://github.com/aws/eks-charts/tree/master/stable/aws-load-balancer-controller/Chart.yaml

Example:
* alb_controller_version = "0.1.12"
DESC
  default     = "1.13.4"
}

# https://github.com/bitnami/charts/tree/main/bitnami/external-dns/Chart.yaml
variable "external_dns_version" {
  type        = string
  description = <<DESC
Version of bitnami/external-dns (defaults "9.0.3")

https://github.com/bitnami/charts/tree/main/bitnami/external-dns/Chart.yaml

Example:
* external_dns_version = "2.20.0"
DESC
  default     = "9.0.3"
}

# https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/Chart.yaml
variable "ingress_nginx_version" {
  type = string

  description = <<DESC
Version of ingress-nginx/ingress-nginx (defaults "4.13.2")

https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/Chart.yaml

Example:
* ingress_nginx_version = "4.12.1"
DESC
  default     = "4.13.2"
}

# https://github.com/kedacore/charts/blob/main/keda/Chart.yaml
variable "keda_version" {
  type        = string
  description = <<DESC
Version of kedacore/keda (defaults "2.17.2")

https://github.com/kedacore/charts/blob/main/keda/Chart.yaml

Example:
* keda_version = "2.20.0"
DESC
  default     = "2.17.2"
}

# https://artifacthub.io/packages/helm/cert-manager/cert-manager?modal=values
variable "cert_manager_version" {
  type        = string
  description = <<DESC
Version of jetstack/cert-manager (defaults "1.18.2")

https://artifacthub.io/packages/helm/cert-manager/cert-manager?modal=values

Example:
* cert_manager_version = "1.7.0"
DESC
  default     = "1.18.2"
}

# https://github.com/DevOps-Nirvana/Kubernetes-Volume-Autoscaler/blob/master/helm-chart/Chart.yaml
variable "volume_autoscaler_version" {
  type        = string
  description = <<DESC
Version of devops-nirvana/volume-autoscaler (defaults "1.0.8")

https://github.com/DevOps-Nirvana/Kubernetes-Volume-Autoscaler/blob/master/helm-chart/Chart.yaml

Example:
* volume_autoscaler_version = "1.7.0"
DESC
  default     = "1.0.8"
}
