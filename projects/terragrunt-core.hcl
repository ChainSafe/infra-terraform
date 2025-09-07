locals {
  # Retrieve configuration of the module
  terragrunt_config_path = "${get_terragrunt_dir()}/terragrunt.hcl"
  terragrunt_stack_name = regex(
    ".*stack_name\\s+=\\s+\"([^\"]+)\"",
    run_cmd(
      "--terragrunt-quiet",
      "grep", "stack_name ", local.terragrunt_config_path
    )
    )[
    0
  ]
  terragrunt_stack_version = regex(
    ".*stack_version\\s+=\\s+\"([^\"]+)\"",
    run_cmd(
      "--terragrunt-quiet",
      "grep", "stack_version ", local.terragrunt_config_path
    )
    )[
    0
  ]
  terragrunt_module_name = join(
    " ",
    [
      local.terragrunt_stack_name,
      local.terragrunt_stack_version
    ]
  )

  # Automatically load global-level variables
  global_vars        = read_terragrunt_config(find_in_parent_folders(".global.hcl"))
  backend_account_id = local.global_vars.locals.backend.account_id
  backend_bucket     = local.global_vars.locals.backend.bucket
  backend_region     = local.global_vars.locals.backend.region

  # Automatically load project-level variables
  project_vars = read_terragrunt_config(find_in_parent_folders(".project.hcl"))
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders(".account.hcl"))
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders(".env.hcl"))

  # Automatically load optional region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders(".region.hcl", find_in_parent_folders(".fallback.hcl")))



  project      = split("/", path_relative_to_include())[0]
  provider     = split("/", path_relative_to_include())[1]
  account_name = split("/", path_relative_to_include())[2]

  config = merge(
    {
      project      = local.project
      cloud        = local.provider
      account_name = local.account_name
    },
    local.global_vars.locals,
    local.project_vars.locals,
    local.region_vars.locals,
    local.account_vars.locals,
    local.environment_vars.locals,
    {
      terragrunt_config = {
        stack_name    = local.terragrunt_stack_name
        stack_version = local.terragrunt_stack_version
      }
    }
  )

  environment_path = join(
    "/",
    [
      local.project,
      local.provider,
      local.account_name
    ]
  )
  stack_path = replace(path_relative_to_include(), local.environment_path, "")
}

# Entry-point for terraform executions
iam_role = "arn:aws:iam::${local.backend_account_id}:role/terraform-management"

terraform {
  extra_arguments "retry_lock" {
    commands = get_terraform_commands_that_need_locking()
    arguments = [
      "-lock-timeout=1m"
    ]
  }

  extra_arguments "init_upgrade" {
    commands = [
      "init"
    ]
    arguments = [
      "-upgrade"
    ]
  }

  extra_arguments "unlock_plan" {
    commands = [
      "plan"
    ]
    arguments = [
      "-lock=false"
    ]
  }

  copy_terraform_lock_file = false
}

# Generate an AWS provider block
generate "provider" {
  disable = local.provider != "aws"

  path      = "aws-provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "aws" {
  region              = "${local.config.region}"
  assume_role {
    role_arn     = "arn:aws:iam::${local.config.account_id}:role/terraform"
    session_name = "terraform"
  }

  default_tags {
    tags = {
      "Environment"                 = "${local.config.env}"
      "Orchestration"               = "Terraform"
      "Project"                     = "${local.config.project}"
      "devops:infrastructure_repo"  = "${local.config.infrastructure_repository}"
      "devops:terraform_module"     = "${local.terragrunt_module_name}"
      component_id                  = "platform_${reverse(split("/", local.terragrunt_stack_name))[0]}"
    }
  }

  ignore_tags {
    key_prefixes = [
      # "kubernetes.io/cluster/",
      "karpenter.sh/discovery",
    ]
  }

  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}
EOF
}

remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    encrypt = true
    bucket  = local.backend_bucket
    key     = "${local.config.infrastructure_repository}/${path_relative_to_include()}/terraform.tfstate"
    region  = local.backend_region

    use_lockfile                = true
    disable_bucket_update       = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this sub-folder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = {
  default_variables = local.config
}
