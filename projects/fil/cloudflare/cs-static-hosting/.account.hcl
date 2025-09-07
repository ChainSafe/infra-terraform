# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt-core.hcl configuration.
locals {
  # ---------------------------------------------------------------------------------------------------------------------
  # Name of the desired account
  #
  # Defined in .account.hcl
  #
  # Example:
  # * account_name = "example"
  # ---------------------------------------------------------------------------------------------------------------------
  account_name = "ChainSafe Static Hosting"

  # ---------------------------------------------------------------------------------------------------------------------
  # ID of the desired account
  #
  # Defined in .account.hcl
  #
  # Example:
  # * account_id = "123456789012"
  # ---------------------------------------------------------------------------------------------------------------------
  account_id = "2238a825c5aca59233eab1f221f7aefb"
}
