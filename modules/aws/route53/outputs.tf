output "public_zone_name" {
  description = "Name of the created public hosted zone"
  value       = var.enable_public_zone ? aws_route53_zone.this[0].name : null
}

output "public_zone_id" {
  description = "ID of the created public hosted zone"
  value       = var.enable_public_zone ? aws_route53_zone.this[0].zone_id : null
}

# output "private_zone_name" {
#   description = "Name of the created private hosted zone"
#   value       = aws_route53_zone.private.name
# }
#
# output "private_zone_id" {
#   description = "ID of the created private hosted zone"
#   value       = aws_route53_zone.private.zone_id
# }
