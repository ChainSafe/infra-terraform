# .global

<!-- BEGIN_TF_DOCS -->


# Terraform
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.13.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_variables"></a> [default\_variables](#input\_default\_variables) | Default variables<br/><br/>* account\_name - Name of the desired AWS account<br/>* account\_id - ID of the desired AWS account<br/>* region - AWS region (defaults "eu-north-1")<br/><br/>* project - Project resource belongs to<br/>* purpose - Purpose of the resource. E.g. "upload-images" (defaults "")<br/>* env - The environment name<br/><br/>* owner - Name of the owner deployed services to belong to (defaults "devops")<br/><br/>* management\_account\_id - Management Account of the AWS Organization (defaults "760950667285") | <pre>object({<br/>    account_name = string<br/>    account_id   = string<br/>    region       = optional(string, "eu-north-1")<br/><br/>    project = string<br/>    purpose = optional(string, "")<br/>    env     = string<br/><br/>    owner = optional(string, "devops")<br/><br/>    management_account_id = optional(string, "760950667285")<br/>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of the custom resource tags (defaults {})<br/><br/>Example:<br/>* tags = {<br/>  Foo = "Bar"<br/>} | `map(string)` | `{}` | no |

## Outputs

No outputs.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.
<!-- END_TF_DOCS -->
