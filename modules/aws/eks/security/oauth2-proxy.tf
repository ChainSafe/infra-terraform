# resource "random_password" "oauth2_cookie_secret" {
#   length           = 32
#   override_special = "-_"
# }
#
# resource "kubernetes_secret_v1" "oauth_proxy" {
#   metadata {
#     name      = "oauth2-proxy-config"
#     namespace = local.namespace
#   }
#   data = {
#     "client-id": "oauth2-proxy"
#     "client-secret": "oauth2-proxy-secret"
#     "cookie-secret": random_password.oauth2_cookie_secret.result
#   }
# }
#
# resource "helm_release" "oauth2_proxy" {
#   name       = "oauth2"
#   chart      = "oauth2-proxy"
#   version    = var.oath2_proxy_version
#   repository = "https://oauth2-proxy.github.io/manifests"
#   namespace  = local.namespace
#
#   values = [
#     templatefile(
#       "${path.module}/values/oauth2-proxy.yaml",
#       {
#         oauth2_secret = kubernetes_secret_v1.oauth_proxy.metadata[0].name
#         organization = var.default_variables.organization
#         email_domain     = var.default_variables.email_domain
#         domain = local.domain_name
#         oauth2_proxy_dns = "auth2.${local.domain_name}"
#         organization     = var.default_variables.organization
#         upstreams = [
#           "https://ara.infra.aws.chainsafe.dev/",
#           # "https://ansible.infra.aws.chainsafe.dev/#/login"
#         ]
#       }
#     )
#   ]
# }
#
#
