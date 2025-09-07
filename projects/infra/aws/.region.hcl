# Set common variables for the region. This is automatically pulled in in the root terragrunt.hcl configuration to
# configure the remote state bucket and pass forward to the child modules as inputs.
locals {
  ################################################################################
  # Cloud region
  #
  # Defined in .env.hcl
  #
  # Example:
  # * region = "us-west-2"
  ################################################################################
  region = "eu-north-1"
}
