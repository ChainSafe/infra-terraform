variable "secrets" {
  type = object({
    cf_api_token = string
  })
  description = <<DESC
Authentication to CloudFlare

Example:
secrets = {
  cf_api_token = "SecretSecret"
}
DESC
  sensitive   = true
}

variable "zome_name" {
  type = string

  description = <<DESC
The name of the CloudFlare zone

Example:
* domain_name = "example.org"
DESC
}

variable "bucket_name" {
  type = string

  description = <<DESC
R2 bucket name (defaults "")

Must be unique within your account
If not provided will be calculated from project and purpose.

Example:
* bucket_name = "foo-assets"
DESC
}

variable "bucket_location" {
  type = string

  description = <<DESC
Location hint for the R2 bucket

Available options:
* apac
* eeur
* enam
* weur
* wnam
* oc

Example:
* bucket_location = "weur"
DESC
}

variable "bucket_jurisdiction" {
  type = string

  description = <<DESC
Jurisdiction for the R2 bucket (defaults "default")

Available options:
* default
* eu
* fedramp

Example:
* bucket_jurisdiction = "eu"
DESC

  default = "default"
}

variable "cors_origins" {
  type = set(string)

  description = <<DESC
Allowed origins for CORS (defaults ["*"])

Example:
* cors_origins = ["https://example.org", "https://app.example.org"]
DESC

  default = ["*"]
}

variable "create_worker" {
  type = bool

  description = <<DESC
Create Worker (defaults false)

Example:
* create_worker = true
DESC

  default = false
}

variable "worker_name" {
  type = string

  description = <<DESC
Name of the Worker service (defaults "")

If not provided will be calculated from project and purpose.

Example:
* worker_name = "foo-worker"
DESC
  default     = ""
}
