# account

<!-- BEGIN_TF_DOCS -->


# Terraform
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudflare"></a> [cloudflare](#input\_cloudflare) | Configuration of CloudFlare federation<br/><br/>Example:<br/>* cloudflare = {<br/>  zone\_name = "example"<br/>  account\_name = "example"<br/>} | <pre>object({<br/>    zone_name    = string<br/>    account_name = string<br/>  })</pre> | <pre>{<br/>  "account_name": "",<br/>  "zone_name": ""<br/>}</pre> | no |
| <a name="input_default_variables"></a> [default\_variables](#input\_default\_variables) | Default variables<br/><br/>* account\_name - Name of the desired AWS account<br/>* account\_id - ID of the desired AWS account<br/>* region - AWS region (defaults "eu-north-1")<br/><br/>* project - Project resource belongs to<br/>* purpose - Purpose of the resource. E.g. "upload-images" (defaults "")<br/>* env - The environment name<br/><br/>* owner - Name of the owner deployed services to belong to (defaults "devops")<br/><br/>* management\_account\_id - Management Account of the AWS Organization (defaults "760950667285") | <pre>object({<br/>    cloud        = string<br/>    account_name = optional(string)<br/>    account_id   = optional(string)<br/>    region       = optional(string, "eu-north-1")<br/><br/>    project = string<br/>    env     = string<br/>    purpose = optional(string, "")<br/><br/>    owner = string<br/><br/>    global_hosted_zone    = string<br/>    management_account_id = string<br/>    platform_account_id   = string<br/>    organization          = string<br/>    email_domain          = string<br/><br/>    infrastructure_repository = string<br/>    terragrunt_config = object(<br/>      {<br/>        stack_name    = optional(string, "")<br/>        stack_version = optional(string, "")<br/>      }<br/>    )<br/>  })</pre> | n/a | yes |
| <a name="input_enable_public_zone"></a> [enable\_public\_zone](#input\_enable\_public\_zone) | If public zone is created (defaults true)<br/><br/>Example:<br/>* enable\_public\_zone = false | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Components of the name<br/><br/>* purpose: Purpose of the resource. E.g. "upload-images"<br/>* separator: Name separator (defaults "-")<br/><br/>Resource name will be <project>-<env>-<purpose>-(\|<type of resource>)<br/><br/>Example:<br/>* name = {<br/>  purpose = "upload-images"<br/>  separator = "\_"<br/>} | <pre>object({<br/>    purpose   = optional(string, "")<br/>    separator = optional(string, "-")<br/>  })</pre> | <pre>{<br/>  "purpose": "",<br/>  "separator": "-"<br/>}</pre> | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Authentication to CloudFlare<br/><br/>Example:<br/>secrets = {<br/>  cf\_api\_token = "SecretSecret"<br/>} | <pre>object({<br/>    cf_api_token = string<br/>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of the custom resource tags (defaults {})<br/><br/>Example:<br/>* tags = {<br/>  Foo = "Bar"<br/>} | `map(string)` | `{}` | no |
| <a name="input_zone_domain"></a> [zone\_domain](#input\_zone\_domain) | Domain for the account hosted zones<br/><br/>Example:<br/>* zone\_domain = "finance" | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_zone_id"></a> [public\_zone\_id](#output\_public\_zone\_id) | ID of the created public hosted zone |
| <a name="output_public_zone_name"></a> [public\_zone\_name](#output\_public\_zone\_name) | Name of the created public hosted zone |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.12.0 |
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 5.9.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [cloudflare_dns_record.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [cloudflare_account.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/account) | data source |
| [cloudflare_zone.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zone) | data source |
<!-- END_TF_DOCS -->
