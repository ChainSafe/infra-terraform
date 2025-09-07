resource "kubernetes_secret" "bootstrap" {
  metadata {
    name      = "bootstrap"
    namespace = local.namespace
  }
  data = {
    "bootstrap.sh" = templatefile(
      "${path.module}/bootstrap/bootstrap.sh.tpl",
      {
        aws_account_id  = data.aws_organizations_organization.this.master_account_id
        sts_role        = aws_iam_role.org_vault.arn
        terraform_role  = local.terraform_role_name
        service_account = kubernetes_service_account.terraform.metadata[0].name
        namespace       = local.namespace
      }
    )
    "admin-policy.hcl"     = file("${path.module}/bootstrap/admin-policy.hcl")
    "terraform-policy.hcl" = file("${path.module}/bootstrap/terraform-policy.hcl")
  }
}

resource "kubernetes_service_account" "terraform" {
  metadata {
    name      = "terraform"
    namespace = local.namespace
  }
}
