locals {
  hc_regions = sort(data.hcloud_datacenters.this.datacenters[*].name)

  node_ids = length(var.instance_ids) != 0 ? var.instance_ids : toset([
    for i in range(var.instance_count) :
    tostring(i)
  ])

  tags = merge(
    local.global_tags,
    var.tags
  )

  labels = {
    for k, v in local.tags :
    replace(k, "/^.*:/", "") => v
  }
}
