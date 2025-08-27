locals {
  # Authentication
  map_roles = merge(
    var.eks_map_roles,
    # {
    #   for role in data.aws_iam_roles.administrators.arns :
    #   role => {
    #     is_admin = true
    #     groups = [
    #       "admin",
    #     ]
    #   }
    # },
  )
}

resource "aws_eks_access_entry" "role" {
  for_each = local.map_roles

  cluster_name      = module.eks.cluster_name
  principal_arn     = each.key
  kubernetes_groups = each.value.groups
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "role" {
  for_each = {
    for k, v in local.map_roles :
    k => v
    if v.is_admin
  }

  cluster_name  = module.eks.cluster_name
  principal_arn = each.key

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"


  access_scope {
    type = "cluster"
  }
}
