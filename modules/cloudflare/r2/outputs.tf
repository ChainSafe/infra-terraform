output "bucket_name" {
  value       = cloudflare_r2_bucket.this.name
  description = "R2 bucket name"
}

output "worker_name" {
  value       = var.create_worker ? cloudflare_worker.this[0].name : ""
  description = "Worker name"
}
