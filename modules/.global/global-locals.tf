locals {
  terraform_role_name = "terraform"

  resource_name = join(
    "-",
    compact(
      [
        var.default_variables.project,
        var.default_variables.project != var.default_variables.purpose ? var.default_variables.purpose : null,
        var.default_variables.env,
      ]
    )
  )

  short_resource_name = join(
    "-",
    compact(
      [
        var.default_variables.project,
        var.default_variables.env,
      ]
    )
  )

  global_tags = {
    Environment   = var.default_variables.env
    Orchestration = "Terraform"
    Project       = var.default_variables.project
  }

  environment_type = reverse(split("-", var.default_variables.account_name))[0]
}
