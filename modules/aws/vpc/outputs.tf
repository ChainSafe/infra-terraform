output "name" {
  description = "The name of the VPC"
  value       = module.vpc.name
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.vpc.vpc_arn
}
