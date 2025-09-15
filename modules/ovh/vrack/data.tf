data "ovh_me" "this" {}

data "ovh_order_cart" "this" {
  ovh_subsidiary = data.ovh_me.this.ovh_subsidiary
}

data "ovh_order_cart_product_plan" "vrack" {
  cart_id        = data.ovh_order_cart.this.id
  price_capacity = "renew"
  product        = "vrack"
  plan_code      = "vrack"
}

data "ovh_dedicated_server" "this" {
  for_each     = var.dedicated_servers
  service_name = each.key
}
