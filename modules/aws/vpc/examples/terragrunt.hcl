# ---------------------------------------------------------------------------------------------------------------------
# You can find latest template for this module at:
# https://github.com/ChainSafe/infra-terraform/tree/main/modules/aws/vpc/examples/
# ---------------------------------------------------------------------------------------------------------------------

locals {
  stack_name    = "modules/aws/vpc"
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
inputs = {
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
  # The CIDR blocks for the VPC
  #
  # Allowed subnets from /16 till /22.
  #
  # Variable allows to configure any CIDRs for the subnets, by default will:
  # * dedicate half of the IP pool to private subnets
  # * dedicate 1/8 of the pool to public, internal, database subnets and spread across AZs
  # If operator provides custom subnet CIDRs he is responsible to ensure that subnets are independent.
  #
  # Example:
  # * cidr = "10.92.0.0/20"
  # ---------------------------------------------------------------------------------------------------------------------
  cidr = {
    vpc =
   # secondary_cidr_blocks = []
   # public_subnets = []
   # private_subnets = []
   # internal_subnets = []
   # database_subnets = []
  }

  # ---------------------------------------------------------------------------------------------------------------------
  # List of Company network (defaults ["10.0.0.0/8"])
  #
  # Default security groups allow HTTPS access from defined networks.
  #
  # Example:
  # * company_networks = [
  #   "1.2.3.4/20",
  # ]
  # ---------------------------------------------------------------------------------------------------------------------
  # company_networks = [
  #   "10.0.0.0/8"
  # ]

  # ---------------------------------------------------------------------------------------------------------------------
  # Configuration of VGW (defaults {asn=0,networks={}})
  # ---------------------------------------------------------------------------------------------------------------------
  # vgw = {
  #   asn = 0
  #   networks = {}
  #  }

  # ---------------------------------------------------------------------------------------------------------------------
  # List of TGWs to attach (defaults [])
  #
  # Expects RAM with tgw names
  #
  # Example:
  # * attach_tgws = ["example-tgw"]
  # ---------------------------------------------------------------------------------------------------------------------
  # attach_tgws = []

  # ---------------------------------------------------------------------------------------------------------------------
  # List of elastic IP names to configure (defaults [])
  #
  # Example:
  # * elastic_ips = [
  #   "example-ip"
  # ]
  # ---------------------------------------------------------------------------------------------------------------------
  # elastic_ips = []

  # ---------------------------------------------------------------------------------------------------------------------
  # If single NAT or NAT per AZ to create (defaults true)
  #
  # Example:
  # * single_nat = false
  # ---------------------------------------------------------------------------------------------------------------------
  # single_nat = true

  # ---------------------------------------------------------------------------------------------------------------------
  # List of letters of the availability zones in desired region (defaults ["a", "b", "c"])
  #
  # Example:
  # * availability_zones = [ "c", "d"]
  # ---------------------------------------------------------------------------------------------------------------------
  # availability_zones = [
  #   "a",
  #   "b",
  #   "c"
  # ]

  # ---------------------------------------------------------------------------------------------------------------------
  # If the subnets without access to internet will be created (defaults false)
  #
  # Typical scenario is subnets for EKS control plane instances
  #
  # Example:
  # * create_internal_subnets = true
  # ---------------------------------------------------------------------------------------------------------------------
  # create_internal_subnets = false

  # ---------------------------------------------------------------------------------------------------------------------
  # If the subnets for the RDS will be created (defaults false)
  #
  # Typical scenario is subnets for RDS instances
  #
  # Example:
  # * create_database_subnets = true
  # ---------------------------------------------------------------------------------------------------------------------
  # create_database_subnets = false

  # ---------------------------------------------------------------------------------------------------------------------
  # If default security group will be managed (defaults true)
  #
  # Example:
  # * manage_default_security_group = false
  # ---------------------------------------------------------------------------------------------------------------------
  # manage_default_security_group = true

  # ---------------------------------------------------------------------------------------------------------------------
  # Map of vpc endpoint services (defaults to example)
  #
  # * service_name - Name of the service, if not provided will find from the key.
  # * service_type - Type of the service: Gateway, GatewayLoadBalancer, or Interface. Defaults "Gateway"
  # * private_dns -  Whether or not to associate a private hosted zone with the specified VPC. Defaults false.
  # * multi_az - Whether to create an endpoint per availability zone. Defaults false
  # * subnet_types - List of subnet types to associate with. If specified will take precedence over subnets_tiers Defaults []
  # * use_default_security_group - Whether or not to use the default security group with VPC endpoint services. Defaults false
  #
  # Example:
  # * endpoint_services = {
  #   s3 = {
  #     service_type = "Gateway"
  #   }
  #   sts = {
  #     service_type = "Interface"
  #   }
  # }
  # ---------------------------------------------------------------------------------------------------------------------
  # endpoint_services = {
  #   s3 = {
  #     service_type = "Gateway"
  #   }
  #  }

}
