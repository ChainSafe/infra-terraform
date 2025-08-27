terraform {
  required_version = "1.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    kubectl = {
      source  = "alekc/kubectl"
      version = "~> 2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }

  backend "remote" {
    organization = "ChainSafe"

    workspaces {
      name = "eks-cluster-test"
    }
  }
}
