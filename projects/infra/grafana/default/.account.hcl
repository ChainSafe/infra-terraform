# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt-core.hcl configuration.
locals {
  # ---------------------------------------------------------------------------------------------------------------------
  # ID of the desired account
  #
  # Defined in .account.hcl
  #
  # Example:
  # * account_id = "123456789012"
  # ---------------------------------------------------------------------------------------------------------------------
  account_id = ""
}
