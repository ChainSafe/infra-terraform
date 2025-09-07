resource "aws_eip" "this" {
  for_each = var.elastic_ips
  domain   = "vpc"
  tags = merge(
    var.tags,
    {
      Name = "${local.vpc_name}-endpoint-${each.key}"
    }
  )

  lifecycle {
    prevent_destroy = true
  }
}
