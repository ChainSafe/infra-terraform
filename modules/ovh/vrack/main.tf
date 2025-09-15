resource "ovh_vrack" "this" {
  ovh_subsidiary = data.ovh_me.this.ovh_subsidiary
  name           = local.resource_name
  description    = local.resource_name

  plan {
    duration     = data.ovh_order_cart_product_plan.vrack.selected_price[0].duration
    plan_code    = data.ovh_order_cart_product_plan.vrack.plan_code
    pricing_mode = data.ovh_order_cart_product_plan.vrack.selected_price[0].pricing_mode
  }

  lifecycle {
    ignore_changes = [
      plan,
      ovh_subsidiary
    ]
  }
}

resource "ovh_vrack_dedicated_server_interface" "this" {
  for_each = var.dedicated_servers

  service_name = ovh_vrack.this.service_name
  interface_id = data.ovh_dedicated_server.this[each.key].enabled_vrack_vnis[0]
}
