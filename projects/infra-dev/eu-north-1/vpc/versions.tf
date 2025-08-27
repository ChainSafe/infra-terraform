terraform {
  required_version = "1.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "remote" {
    organization = "ChainSafe"

    workspaces {
      name = "eks-cluster-test-vpc"
    }
  }
}
