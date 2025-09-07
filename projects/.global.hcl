# Set repository-wide variables. These are automatically pulled in in the root terragrunt-core.hcl configuration to
# feed forward to the child modules.
locals {
  ################################################################################
  # Infrastructure repository name
  #
  # Defined in .global.hcl
  #
  # Example:
  # * infrastructure_repository = "infrastructure-example"
  ################################################################################
  infrastructure_repository = "infra-terraform"

  ################################################################################
  # Owner name
  #
  # Defined in .global.hcl
  #
  # Example:
  # * owner = "example"
  ################################################################################
  owner = "devops"

  ################################################################################
  # Configuration of the terraform states
  #
  # Should not be changed
  ################################################################################
  backend = {
    account_id = "905418303280"
    region     = "eu-north-1"
    bucket     = "chainsafe-terraform-states"
  }

  global_hosted_zone    = "chainsafe.dev"
  management_account_id = "760950667285"
  platform_account_id   = "905418303280"
  organization          = "ChainSafe"
  email_domain          = "chainsafe.io"
}
