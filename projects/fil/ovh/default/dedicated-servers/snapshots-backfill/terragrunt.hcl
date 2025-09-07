# ---------------------------------------------------------------------------------------------------------------------
# You can find latest template for this module at:
# https://github.com/ChainSafe/infra-terraform/tree/main/modules/ovh/dedicated-servers/examples/
# ---------------------------------------------------------------------------------------------------------------------

locals {
  stack_name    = "modules/ovh/dedicated-servers"
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
    # Resource name will be <org>-<product>-<purpose>-<env>( | -<type of resource>)
    #
    # Example:
    # * name = {
    #   purpose = "upload-images"
    #   separator = "_"
    # }
    # ---------------------------------------------------------------------------------------------------------------------
    name = {
      purpose = "forest-calibnet"
      # separator = "-"
    }

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
    # The subdomain of application (defaults "")
    #
    # Example:
    # * subdomain = "api"
    # ---------------------------------------------------------------------------------------------------------------------
    # subdomain = ""

    # ---------------------------------------------------------------------------------------------------------------------
    # Dedicate Server IDs and names for configuration (defaults {})
    #
    #
    # Example:
    # * servers = {
    #   "nsxxxxxxx.ip-xx-xx-xx.eu" = "api-foo-back"
    # }
    # ---------------------------------------------------------------------------------------------------------------------
    servers = {
      "ns3262103.ip-57-128-233.eu" = "snapshots-backfill"
    }

    # ---------------------------------------------------------------------------------------------------------------------
    # Configuration of Servers
    #
    # Available options:
    # * os - https://ca.api.ovh.com/v1/dedicated/installationTemplate
    # * ssh - AWX public key
    # * script - Post installation script
    #
    # Example:
    # * configuration = {
    #   os = "ubuntu2404-server_64"
    #
    #   script = <<-SCRIPT
    #   #!/bin/bash
    #   hostnamectl set-hostname ${hostname}
    #   SCRIPT
    # }
    # ---------------------------------------------------------------------------------------------------------------------
    # configuration = {
    #   intervention = true
    #   monitoring = true
    #   os = "ubuntu2404-server_64"
    #   script = "#!/bin/bash\napt update\napt install -y ansible git wget\n\ngit clone \"https://github.com/next-gen-infrastructure/ansible-public.git\" /tmp/bootstrap\n# ansible-playbook -i localhost, -c local /tmp/bootstrap/bootstrap.yml --check\n"
    #   ssh_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQdyDPqu80ZSimqReNHZhHN7xTSK4CXTHjI2nZlQ911 awx@chainsafe.io"
    #  }

    # ---------------------------------------------------------------------------------------------------------------------
    # The name of the zone (defaults null)
    #
    # Example:
    # * domain_name = "example.org"
    # ---------------------------------------------------------------------------------------------------------------------
    # domain_name = null

  }
)
