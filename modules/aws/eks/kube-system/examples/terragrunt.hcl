# ---------------------------------------------------------------------------------------------------------------------
# You can find latest template for this module at:
# https://github.com/ChainSafe/infra-terraform/tree/main/modules/aws/eks/kube-system/examples/
# ---------------------------------------------------------------------------------------------------------------------

locals {
  stack_name    = "modules/aws/eks/kube-system"
  stack_version = "main" # FIXME: Please update version if required

  stack_host       = "git::git@github.com"
  stack_repository = "ChainSafe/infra-terraform"
}

# Terragrunt will copy the Terraform configurations specified by the source
# parameter, along with any files in the working directory,
# into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${local.stack_host}:${local.stack_repository}.git//${local.stack_name}?ref=${local.stack_version}"
}

include "root" {
  path = find_in_parent_folders("terragrunt-core.hcl")
}


# TODO: These are the variables we have to pass in to use the module specified in the terragrunt configuration above:
inputs = {
  # ---------------------------------------------------------------------------------------------------------------------
  # Components of the name
  #
  # * purpose: Purpose of the resource. E.g. "upload-images"
  # * separator: Name separator (defaults "-")
  #
  Resource name will be <project>-<env>-<purpose>-(|<type of resource>)
  #
  # Example:
  # * name = {
  #   purpose = "upload-images"
  #   separator = "_"
  # }
  # ---------------------------------------------------------------------------------------------------------------------
  # name = {
  #   purpose = ""
  #   separator = "-"
  # }

  # ---------------------------------------------------------------------------------------------------------------------
  # Map of the custom resource tags (defaults {})
  #
  # Example:
  # * tags = {
  #   Foo = "Bar"
  # }
  # ---------------------------------------------------------------------------------------------------------------------
  # tags = {}

  # ---------------------------------------------------------------------------------------------------------------------
  # Name of the EKS cluster
  #
  # If not provided will use account name
  #
  # Example:
  # * cluster_name = "dev"
  # ---------------------------------------------------------------------------------------------------------------------
  # cluster_name = ""

  # ---------------------------------------------------------------------------------------------------------------------
  # Version of eks/aws-load-balancer-controller (defaults "1.13.4")
  #
  # https://github.com/aws/eks-charts/tree/master/stable/aws-load-balancer-controller/Chart.yaml
  #
  # Example:
  # * alb_controller_version = "0.1.12"
  # ---------------------------------------------------------------------------------------------------------------------
  # alb_controller_version = "1.13.4"

  # ---------------------------------------------------------------------------------------------------------------------
  # Version of bitnami/external-dns (defaults "9.0.3")
  #
  # https://github.com/bitnami/charts/tree/main/bitnami/external-dns/Chart.yaml
  #
  # Example:
  # * external_dns_version = "2.20.0"
  # ---------------------------------------------------------------------------------------------------------------------
  # external_dns_version = "9.0.3"

  # ---------------------------------------------------------------------------------------------------------------------
  # Version of ingress-nginx/ingress-nginx (defaults "4.13.2")
  #
  # https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/Chart.yaml
  #
  # Example:
  # * ingress_nginx_version = "4.12.1"
  # ---------------------------------------------------------------------------------------------------------------------
  # ingress_nginx_version = "4.13.2"

  # ---------------------------------------------------------------------------------------------------------------------
  # Version of kedacore/keda (defaults "2.17.2")
  #
  # https://github.com/kedacore/charts/blob/main/keda/Chart.yaml
  #
  # Example:
  # * keda_version = "2.20.0"
  # ---------------------------------------------------------------------------------------------------------------------
  # keda_version = "2.17.2"

  # ---------------------------------------------------------------------------------------------------------------------
  # Version of jetstack/cert-manager (defaults "1.18.2")
  #
  # https://artifacthub.io/packages/helm/cert-manager/cert-manager?modal=values
  #
  # Example:
  # * cert_manager_version = "1.7.0"
  # ---------------------------------------------------------------------------------------------------------------------
  # cert_manager_version = "1.18.2"

  # ---------------------------------------------------------------------------------------------------------------------
  # Version of devops-nirvana/volume-autoscaler (defaults "1.0.8")
  #
  # https://github.com/DevOps-Nirvana/Kubernetes-Volume-Autoscaler/blob/master/helm-chart/Chart.yaml
  #
  # Example:
  # * volume_autoscaler_version = "1.7.0"
  # ---------------------------------------------------------------------------------------------------------------------
  # volume_autoscaler_version = "1.0.8"

}
