# droplet

<!-- BEGIN_TF_DOCS -->


# Terraform
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10 |
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | ~> 2.106 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.6 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backups"></a> [backups](#input\_backups) | Enable DigitalOcean droplet backups (defaults true)<br/><br/>Example:<br/>* backups = true | `bool` | `true` | no |
| <a name="input_default_variables"></a> [default\_variables](#input\_default\_variables) | Default variables<br/><br/>* account\_name - Name of the desired AWS account<br/>* account\_id - ID of the desired AWS account<br/>* region - AWS region (defaults "eu-north-1")<br/><br/>* project - Project resource belongs to<br/>* purpose - Purpose of the resource. E.g. "upload-images" (defaults "")<br/>* env - The environment name<br/><br/>* owner - Name of the owner deployed services to belong to (defaults "devops")<br/><br/>* management\_account\_id - Management Account of the AWS Organization (defaults "760950667285") | <pre>object({<br/>    cloud        = string<br/>    account_name = optional(string)<br/>    account_id   = optional(string)<br/>    region       = optional(string, "eu-north-1")<br/><br/>    project = string<br/>    env     = string<br/>    purpose = optional(string, "")<br/><br/>    owner = string<br/><br/>    global_hosted_zone    = string<br/>    management_account_id = string<br/>    platform_account_id   = string<br/>    organization          = string<br/>    email_domain          = string<br/><br/>    infrastructure_repository = string<br/>    terragrunt_config = object(<br/>      {<br/>        stack_name    = optional(string, "")<br/>        stack_version = optional(string, "")<br/>      }<br/>    )<br/>  })</pre> | n/a | yes |
| <a name="input_droplet_tags"></a> [droplet\_tags](#input\_droplet\_tags) | DigitalOcean tags attached to the droplet (defaults [])<br/><br/>Example:<br/>* droplet\_tags = [<br/>  "blog",<br/>  "ghost"<br/>] | `set(string)` | `[]` | no |
| <a name="input_image"></a> [image](#input\_image) | The image slug or ID (defaults "ubuntu-24-04-x64")<br/><br/>Example:<br/>* image = "ubuntu-24-04-x64" | `string` | `"ubuntu-24-04-x64"` | no |
| <a name="input_name"></a> [name](#input\_name) | Components of the name<br/><br/>* purpose: Purpose of the resource. E.g. "upload-images"<br/>* separator: Name separator (defaults "-")<br/><br/>Resource name will be <project>-<env>-<purpose>-(\|<type of resource>)<br/><br/>Example:<br/>* name = {<br/>  purpose = "upload-images"<br/>  separator = "\_"<br/>} | <pre>object({<br/>    purpose   = optional(string, "")<br/>    separator = optional(string, "-")<br/>  })</pre> | <pre>{<br/>  "purpose": "",<br/>  "separator": "-"<br/>}</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | The DigitalOcean region slug<br/><br/>Example:<br/>* region = "tor1" | `string` | n/a | yes |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Authentication to DigitalOcean<br/><br/>Example:<br/>secrets = {<br/>  do\_token = "SecretSecret"<br/>} | <pre>object({<br/>    do_token = string<br/>  })</pre> | n/a | yes |
| <a name="input_size"></a> [size](#input\_size) | The droplet size slug (defaults "s-1vcpu-2gb")<br/><br/>More details: https://slugs.do-api.dev/<br/><br/>Example:<br/>* size = "s-2vcpu-4gb" | `string` | `"s-1vcpu-2gb"` | no |
| <a name="input_ssh_allowlist"></a> [ssh\_allowlist](#input\_ssh\_allowlist) | Source CIDRs allowed to reach SSH on port 22 (defaults [], SSH closed)<br/><br/>Example:<br/>* ssh\_allowlist = [<br/>  "203.0.113.10/32"<br/>] | `list(string)` | `[]` | no |
| <a name="input_ssh_keys"></a> [ssh\_keys](#input\_ssh\_keys) | The list of SSH key IDs or fingerprints already in the DigitalOcean account (at least one)<br/><br/>Example:<br/>* ssh\_keys = [<br/>  "12:34:45:65:df:ds:3f:2s:14:sx:qw:er:ty:yu:ui:fg"<br/>] | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of the custom resource tags (defaults {})<br/><br/>Example:<br/>* tags = {<br/>  Foo = "Bar"<br/>} | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_droplet_id"></a> [droplet\_id](#output\_droplet\_id) | ID of the droplet |
| <a name="output_reserved_ip"></a> [reserved\_ip](#output\_reserved\_ip) | Reserved IP assigned to the droplet |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | 2.106.0 |
| <a name="provider_http"></a> [http](#provider\_http) | 3.6.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [digitalocean_droplet.this](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/droplet) | resource |
| [digitalocean_firewall.this](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/firewall) | resource |
| [digitalocean_reserved_ip.this](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/reserved_ip) | resource |
| [digitalocean_reserved_ip_assignment.this](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/reserved_ip_assignment) | resource |
| [http_http.cloudflare_ips_v4](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.cloudflare_ips_v6](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
<!-- END_TF_DOCS -->
