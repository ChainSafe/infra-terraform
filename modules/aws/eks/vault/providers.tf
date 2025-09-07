provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

# FIXME: cross-account vault access
# provider "aws" {
#   alias = "org"
#
#   region = var.default_variables.region
#   assume_role {
#     role_arn     = "arn:aws:iam::${data.aws_organizations_organization.this.master_account_id}:role/${local.terraform_role_name}"
#     session_name = "terraform"
#   }
#
#   default_tags {
#     tags = local.global_tags
#   }
#
#   ignore_tags {
#     key_prefixes = [
#       "kubernetes.io/cluster/"
#     ]
#   }
#
#   skip_metadata_api_check     = true
#   skip_region_validation      = true
#   skip_credentials_validation = true
# }
