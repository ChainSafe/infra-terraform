resource "cloudflare_r2_bucket" "this" {
  account_id = data.cloudflare_account.this.account_id
  name       = local.bucket_name

  location = upper(var.bucket_location)

  jurisdiction = var.bucket_jurisdiction
}

resource "cloudflare_r2_bucket_cors" "this" {
  count = var.cors_origins != ["*"] ? 1 : 0

  account_id  = cloudflare_r2_bucket.this.account_id
  bucket_name = cloudflare_r2_bucket.this.name

  rules = [
    {
      allowed = {
        methods = ["GET", "HEAD", "PUT", "POST", "DELETE"]
        origins = var.cors_origins
        headers = ["*"]
      }
      max_age_seconds = 86400
    }
  ]
}

resource "cloudflare_worker" "this" {
  count      = var.create_worker ? 1 : 0
  account_id = data.cloudflare_account.this.account_id
  name       = local.worker_name
}
