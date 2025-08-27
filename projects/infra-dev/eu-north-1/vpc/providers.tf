provider "aws" {
  region = var.default_variables.region
  allowed_account_ids = [
    var.default_variables.account_id
  ]

  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}
