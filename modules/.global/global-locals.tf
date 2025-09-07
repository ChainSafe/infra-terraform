locals {
  terraform_role_name = "terraform"
  resource_name = join(
    var.name.separator,
    compact(
      [
        var.default_variables.project,
        var.default_variables.env,
        var.default_variables.cloud,
        var.default_variables.project != var.name.purpose ? var.name.purpose : null,
      ]
    )
  )

  short_resource_name = join(
    var.name.separator,
    compact(
      [
        var.default_variables.project,
        var.default_variables.env,
        var.default_variables.cloud,
      ]
    )
  )

  global_tags = {
    Environment                  = var.default_variables.env
    Orchestration                = "Terraform"
    Project                      = var.default_variables.project
    "devops:infrastructure_repo" = var.default_variables.infrastructure_repository
    "devops:terraform_module" = join(
      " ", [
        var.default_variables.terragrunt_config.stack_name,
        var.default_variables.terragrunt_config.stack_version
      ]
    )
  }
}
