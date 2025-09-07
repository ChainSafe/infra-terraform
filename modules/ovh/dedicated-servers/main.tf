# noinspection HILUnresolvedReference
resource "ovh_dedicated_server" "this" {
  for_each = var.servers

  service_name   = each.key
  ovh_subsidiary = data.ovh_me.this.ovh_subsidiary
  display_name = join(
    var.name.separator,
    compact(
      [
        local.resource_name,
        each.value
      ]
    )
  )
  os = data.ovh_dedicated_installation_template.this.template_name

  customizations = {
    hostname = substr(
      join(
        var.name.separator,
        compact(
          [
            local.resource_name,
            each.value
          ]
        )
    ), 0, 63)
    post_installation_script = base64encode(var.configuration.script)
    ssh_key                  = var.configuration.ssh_key
  }
}
