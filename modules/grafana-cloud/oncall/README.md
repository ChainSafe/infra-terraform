# Grafana Cloud IRM

<!-- BEGIN_TF_DOCS -->


# Terraform
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10 |
| <a name="requirement_grafana"></a> [grafana](#requirement\_grafana) | ~> 4.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | ~> 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_variables"></a> [default\_variables](#input\_default\_variables) | Default variables<br/><br/>* account\_name - Name of the desired AWS account<br/>* account\_id - ID of the desired AWS account<br/>* region - AWS region (defaults "eu-north-1")<br/><br/>* project - Project resource belongs to<br/>* purpose - Purpose of the resource. E.g. "upload-images" (defaults "")<br/>* env - The environment name<br/><br/>* owner - Name of the owner deployed services to belong to (defaults "devops")<br/><br/>* management\_account\_id - Management Account of the AWS Organization (defaults "760950667285") | <pre>object({<br/>    cloud        = string<br/>    account_name = optional(string)<br/>    account_id   = optional(string)<br/>    region       = optional(string, "eu-north-1")<br/><br/>    project = string<br/>    env     = string<br/>    purpose = optional(string, "")<br/><br/>    owner = string<br/><br/>    global_hosted_zone    = string<br/>    management_account_id = string<br/>    platform_account_id   = string<br/>    organization          = string<br/>    email_domain          = string<br/><br/>    infrastructure_repository = string<br/>    terragrunt_config = object(<br/>      {<br/>        stack_name    = optional(string, "")<br/>        stack_version = optional(string, "")<br/>      }<br/>    )<br/>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Components of the name<br/><br/>* purpose: Purpose of the resource. E.g. "upload-images"<br/>* separator: Name separator (defaults "-")<br/><br/>Resource name will be <project>-<env>-<purpose>-(\|<type of resource>)<br/><br/>Example:<br/>* name = {<br/>  purpose = "upload-images"<br/>  separator = "\_"<br/>} | <pre>object({<br/>    purpose   = optional(string, "")<br/>    separator = optional(string, "-")<br/>  })</pre> | <pre>{<br/>  "purpose": "",<br/>  "separator": "-"<br/>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of the custom resource tags (defaults {})<br/><br/>Example:<br/>* tags = {<br/>  Foo = "Bar"<br/>} | `map(string)` | `{}` | no |
| <a name="input_team_managers"></a> [team\_managers](#input\_team\_managers) | List of team managers (defaults [])<br/><br/>Example:<br/>* team\_managers = [<br/>  "joshdougall"<br/>] | `set(string)` | `[]` | no |
| <a name="input_team_members"></a> [team\_members](#input\_team\_members) | List of on-call users (defaults [])<br/><br/>Example:<br/>* team\_members = [<br/>  "adobrodey"<br/>] | `list(string)` | `[]` | no |
| <a name="input_team_name"></a> [team\_name](#input\_team\_name) | Name of the on-call team<br/><br/>Example:<br/>* team\_name = "devops" | `string` | n/a | yes |
| <a name="input_time_zone"></a> [time\_zone](#input\_time\_zone) | Timezone of the on-call rotation (defaults "UTC")<br/><br/>Example:<br/>* time\_zone = "Europe/Berlin" | `string` | `"UTC"` | no |

## Outputs

No outputs.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_grafana"></a> [grafana](#provider\_grafana) | 4.11.1 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 5.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [grafana_oncall_escalation.critical_manager](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/oncall_escalation) | resource |
| [grafana_oncall_escalation.critical_manager_wait](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/oncall_escalation) | resource |
| [grafana_oncall_escalation.critical_on_call](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/oncall_escalation) | resource |
| [grafana_oncall_escalation.critical_on_call_wait](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/oncall_escalation) | resource |
| [grafana_oncall_escalation.critical_repeat](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/oncall_escalation) | resource |
| [grafana_oncall_escalation.critical_team](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/oncall_escalation) | resource |
| [grafana_oncall_escalation.critical_team_wait](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/oncall_escalation) | resource |
| [grafana_oncall_escalation.warning_on_call](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/oncall_escalation) | resource |
| [grafana_oncall_escalation.warning_on_call_wait](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/oncall_escalation) | resource |
| [grafana_oncall_escalation.warning_repeat](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/oncall_escalation) | resource |
| [grafana_oncall_escalation.warning_team](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/oncall_escalation) | resource |
| [grafana_oncall_escalation.warning_team_wait](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/oncall_escalation) | resource |
| [grafana_oncall_escalation_chain.critical](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/oncall_escalation_chain) | resource |
| [grafana_oncall_escalation_chain.warning](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/oncall_escalation_chain) | resource |
| [grafana_oncall_on_call_shift.this](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/oncall_on_call_shift) | resource |
| [grafana_oncall_schedule.this](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/oncall_schedule) | resource |
| [grafana_oncall_team.this](https://registry.terraform.io/providers/grafana/grafana/latest/docs/data-sources/oncall_team) | data source |
| [grafana_oncall_users.this](https://registry.terraform.io/providers/grafana/grafana/latest/docs/data-sources/oncall_users) | data source |
| [grafana_team.this](https://registry.terraform.io/providers/grafana/grafana/latest/docs/data-sources/team) | data source |
| [vault_kv_secret_v2.grafana](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/kv_secret_v2) | data source |
<!-- END_TF_DOCS -->
