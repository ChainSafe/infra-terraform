resource "aws_ec2_tag" "subnet" {
  for_each = toset(data.aws_subnets.nodes.ids)

  resource_id = each.value
  key         = "karpenter.sh/discovery/${local.cluster_name}"
  value       = "1"
}
