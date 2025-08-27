resource "aws_security_group" "additional" {
  name_prefix = "${local.cluster_name}-additional"
  vpc_id      = data.aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name                                           = "${local.cluster_name}-additional"
      "karpenter.sh/discovery/${local.cluster_name}" = "1"
      "kubernetes.io/cluster/${local.cluster_name}"  = "owned"
    }
  )
}

resource "aws_security_group_rule" "ephemeral_http" {
  security_group_id = aws_security_group.additional.id

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 1025
  to_port     = 65535
  description = "Health Checks for Network load balancers"
  cidr_blocks = [
    data.aws_vpc.this.cidr_block
  ]
}
