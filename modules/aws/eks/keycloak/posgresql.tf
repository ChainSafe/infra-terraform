resource "helm_release" "postgresql_operator" {
  name      = "cnpg"
  namespace = local.namespace

  chart      = "cloudnative-pg"
  repository = "https://cloudnative-pg.github.io/charts"
  replace    = true
}

resource "helm_release" "postgresql_db" {
  name      = "postgresql"
  namespace = local.namespace

  chart      = "cluster"
  repository = "https://cloudnative-pg.github.io/charts"
  replace    = true

  values = [
    <<EOF
type: postgresql
mode: standalone
version:
  postgresql: "16"
cluster:
  instances: 1
backups:
  enabled: false
EOF
  ]

  depends_on = [
    helm_release.postgresql_operator
  ]
}

data "kubernetes_secret_v1" "database_password" {
  metadata {
    name      = "postgresql-cluster-superuser"
    namespace = local.namespace
  }

  depends_on = [
    helm_release.postgresql_db
  ]
}
