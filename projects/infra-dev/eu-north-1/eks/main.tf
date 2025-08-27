module "eks" {
  source = "../../../../../aws/modules/eks/cluster"

  default_variables = var.default_variables
  tags              = {}

  cluster_name     = "test"
  api_access_cidrs = ["0.0.0.0/0"]

  subnet_types = {
    nodes         = "private"
    control_plane = "public"
  }
}

module "kube_system" {
  source = "../../../../../aws/modules/eks/kube-system"

  default_variables = var.default_variables
  tags              = {}

  cluster_name = module.eks.cluster_name

  depends_on = [
    module.eks
  ]
}

module "karpenter" {
  source = "../../../../../aws/modules/eks/karpenter"

  default_variables = var.default_variables
  tags              = {}

  cluster_name = module.eks.cluster_name

  depends_on = [
    module.eks
  ]
}
