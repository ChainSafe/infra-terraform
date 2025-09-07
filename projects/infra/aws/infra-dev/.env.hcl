# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# configure the remote state bucket and pass forward to the child modules as inputs.
locals {
  ################################################################################
  # The environment name (defaults "dev")
  #
  # Defined in .env.hcl
  #
  # Example:
  # * env = "sandbox"
  ################################################################################
  env = "dev"
}
