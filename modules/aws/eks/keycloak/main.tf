resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = "keycloak"
  }
}

resource "random_uuid" "admin" {}

resource "kubernetes_secret_v1" "admin" {
  metadata {
    name      = "keycloak-auth"
    namespace = local.namespace
  }
  data = {
    "admin-password" = random_uuid.admin.result
  }
}

locals {
  namespace    = kubernetes_namespace_v1.this.metadata[0].name
  keycloak_dns = "auth.${local.domain_name}"
}

resource "helm_release" "this" {
  name      = "keycloak"
  namespace = local.namespace

  chart      = "keycloakx"
  version    = var.keycloak_version
  repository = "oci://ghcr.io/codecentric/helm-charts"
  replace    = true

  values = [
    templatefile(
      "${path.module}/values/keycloak.yaml",
      {
        keycloak_dns = local.keycloak_dns
        auth_secret  = kubernetes_secret_v1.admin.metadata[0].name
        db_secret    = data.kubernetes_secret_v1.database_password.metadata[0].name
      }
    )
  ]
}

data "keycloak_realm" "master" {
  realm = "master"

  depends_on = [
    helm_release.this
  ]
}

data "keycloak_role" "this" {
  realm_id = data.keycloak_realm.master.id
  name     = "admin"
}

resource "keycloak_openid_client" "terraform" {
  realm_id  = data.keycloak_realm.master.id
  name      = "terraform"
  client_id = "terraform"
  enabled   = true

  access_type = "CONFIDENTIAL"
  login_theme = "keycloak"

  service_accounts_enabled = true
}

resource "keycloak_openid_client_service_account_realm_role" "terraform" {
  realm_id                = data.keycloak_realm.master.id
  role                    = data.keycloak_role.this.name
  service_account_user_id = keycloak_openid_client.terraform.service_account_user_id
}
