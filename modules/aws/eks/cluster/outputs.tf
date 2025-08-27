output "cluster_name" {
  value       = module.eks.cluster_name
  description = "Name of the cluster"
}

output "node_iam_role_arn" {
  value       = aws_iam_role.eks_managed.arn
  description = "ARN of the managed Nodes IAM Role"
}
