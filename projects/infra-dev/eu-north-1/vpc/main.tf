module "vpc" {
  source = "../../../../../aws/modules/vpc"

  default_variables = var.default_variables
  tags              = var.tags

  cidr = {
    vpc = "10.72.0.0/16"
  }

  availability_zones = ["a", "b", "c"]
}
