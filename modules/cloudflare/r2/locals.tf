locals {
  bucket_name = var.bucket_name != "" ? var.bucket_name : local.resource_name
  worker_name = var.worker_name != "" ? var.worker_name : local.resource_name
}
