resource "aws_efs_file_system" "efs_driver" {
  creation_token = data.aws_eks_cluster.this.name
  encrypted      = true

  lifecycle_policy {
    transition_to_ia = "AFTER_14_DAYS"
  }

  tags = merge(
    var.tags,
    {
      Name = data.aws_eks_cluster.this.name
    }
  )
}

resource "aws_security_group" "efs" {
  name        = "${data.aws_eks_cluster.this.name}-efs"
  description = "Allow EFS access from ${data.aws_eks_cluster.this.name}"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    description = "EFS"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    security_groups = [
      data.aws_eks_cluster.this.vpc_config[0].cluster_security_group_id,
      data.aws_security_group.node.id
    ]
  }

  tags = merge(
    var.tags,
    {
      Name = "${data.aws_eks_cluster.this.name}-efs"
    }
  )
}

resource "aws_efs_mount_target" "efs_driver" {
  for_each       = toset(data.aws_subnets.private.ids)
  file_system_id = aws_efs_file_system.efs_driver.id
  subnet_id      = each.value
  security_groups = [
    aws_security_group.efs.id,
  ]
}
