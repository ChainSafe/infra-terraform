config {
  format              = "compact"
  call_module_type    = "all"
  force               = false
  disabled_by_default = false

}

plugin "aws" {
  enabled = true
  version = "0.42.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

plugin "terraform" {
  enabled = true
  version = "0.13.0"
  source  = "github.com/terraform-linters/tflint-ruleset-terraform"
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = false
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
}

rule "terraform_standard_module_structure" {
  enabled = false
}
