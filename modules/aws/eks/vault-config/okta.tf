# resource "okta_app_oauth" "this" {
#   label          = "vault-${local.environment_type}"
#   type           = "web"
#   grant_types    = ["authorization_code"]
#   redirect_uris  = [local.vault_url]
#   response_types = ["code"]
# }
#

# data "okta_app_oauth" "this" {
#   label = "vault-test"
# }

# data "okta_group" "admins" {
#   for_each = var.admin_groups
#   name     = each.key
# }

# resource "okta_app_group_assignment" "admins" {
#   for_each = var.admin_groups
#
#   app_id   = data.okta_app_oauth.this.id
#   group_id = data.okta_group.admins[each.key].id
# }
