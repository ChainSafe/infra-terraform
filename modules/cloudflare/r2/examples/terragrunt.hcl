# ---------------------------------------------------------------------------------------------------------------------
# You can find latest template for this module at:
# https://github.com/ChainSafe/infra-terraform/tree/main/modules/cloudflare/r2/examples/
# ---------------------------------------------------------------------------------------------------------------------

locals {
  stack_name    = "modules/cloudflare/r2"
  stack_version = "main" # FIXME: Please update version if required

  stack_host       = "git::git@github.com"
  stack_repository = "ChainSafe/infra-terraform"
}

# Terragrunt will copy the Terraform configurations specified by the source
# parameter, along with any files in the working directory,
# into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${local.stack_host}:${local.stack_repository}.git//${local.stack_name}?ref=${local.stack_version}"
}

include "root" {
  path = find_in_parent_folders("terragrunt-core.hcl")
}


# TODO: These are the variables we have to pass in to use the module specified in the terragrunt configuration above:
inputs = merge(
  try(
    yamldecode(
      sops_decrypt_file("secrets.tfvars.yaml")
    ),
    yamldecode(
      file("secrets.tfvars.yaml")
    )
  ),
  {
        # ---------------------------------------------------------------------------------------------------------------------
    # Components of the name
    #
    # * purpose: Purpose of the resource. E.g. "upload-images"
    # * separator: Name separator (defaults "-")
    #
    # Resource name will be <project>-<env>-<purpose>-(|<type of resource>)
    #
    # Example:
    # * name = {
    #   purpose = "upload-images"
    #   separator = "_"
    # }
    # ---------------------------------------------------------------------------------------------------------------------
    # name = {
    #   purpose = ""
    #   separator = "-"
    # }

    # ---------------------------------------------------------------------------------------------------------------------
    # Map of the custom resource tags (defaults {})
    #
    # Example:
    # * tags = {
    #   Foo = "Bar"
    # }
    # ---------------------------------------------------------------------------------------------------------------------
    # tags = {}

    # ---------------------------------------------------------------------------------------------------------------------
    # Name of the Worker service (defaults "")
    #
    # If not provided will be calculated from project and purpose.
    #
    # Example:
    # * worker_name = "foo-worker"
    # ---------------------------------------------------------------------------------------------------------------------
    # worker_name = ""

    # ---------------------------------------------------------------------------------------------------------------------
    # The name of the CloudFlare zone
    #
    # Example:
    # * domain_name = "example.org"
    # ---------------------------------------------------------------------------------------------------------------------
    zome_name =

    # ---------------------------------------------------------------------------------------------------------------------
    # R2 bucket name (defaults "")
    #
    # Must be unique within your account
    # If not provided will be calculated from project and purpose.
    #
    # Example:
    # * bucket_name = "foo-assets"
    # ---------------------------------------------------------------------------------------------------------------------
    bucket_name =

    # ---------------------------------------------------------------------------------------------------------------------
    # Location hint for the R2 bucket
    #
    # Available options:
    # * apac
    # * eeur
    # * enam
    # * weur
    # * wnam
    # * oc
    #
    # Example:
    # * bucket_location = "weur"
    # ---------------------------------------------------------------------------------------------------------------------
    bucket_location =

    # ---------------------------------------------------------------------------------------------------------------------
    # Jurisdiction for the R2 bucket (defaults "default")
    #
    # Available options:
    # * default
    # * eu
    # * fedramp
    #
    # Example:
    # * bucket_jurisdiction = "eu"
    # ---------------------------------------------------------------------------------------------------------------------
    # bucket_jurisdiction = "default"

    # ---------------------------------------------------------------------------------------------------------------------
    # Allowed origins for CORS (defaults ["*"])
    #
    # Example:
    # * cors_origins = ["https://example.org", "https://app.example.org"]
    # ---------------------------------------------------------------------------------------------------------------------
    # cors_origins = [
    #   "*"
    # ]

    # ---------------------------------------------------------------------------------------------------------------------
    # Create Worker (defaults false)
    #
    # Example:
    # * create_worker = true
    # ---------------------------------------------------------------------------------------------------------------------
    # create_worker = false

  }
)
