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

provider "kubectl" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
  load_config_file       = false
}

provider "vault" {
  address               = "https://vault.infra.aws.${var.default_variables.global_hosted_zone}"
  max_lease_ttl_seconds = 1800

  auth_login_aws {
    role                  = local.terraform_role_name
    aws_role_arn          = "arn:aws:iam::${var.default_variables.platform_account_id}:role/${local.terraform_role_name}"
    aws_role_session_name = "vault"
  }
}
