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

provider "vault" {
  address               = local.vault_url
  max_lease_ttl_seconds = 1800

  auth_login_aws {
    role                  = local.terraform_role_name
    aws_role_arn          = "arn:aws:iam::${var.default_variables.platform_account_id}:role/${local.terraform_role_name}"
    aws_role_session_name = "vault"
  }
}

provider "keycloak" {
  url           = local.keycloak_url
  client_id     = "admin-cli"
  username      = data.vault_kv_secret_v2.keycloak.data.username
  password      = data.vault_kv_secret_v2.keycloak.data.password
  initial_login = false
}
