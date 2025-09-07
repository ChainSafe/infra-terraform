# servers

<!-- BEGIN_TF_DOCS -->


# Terraform
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | >= 5 |
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | >= 1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access"></a> [access](#input\_access) | Configuration of network access to servers (defaults {})<br/><br/>Key is a port, value is list of source addresses<br/><br/>Example:<br/>* access = {<br/>    "80" = [<br/>        "10.0.0.0/8",<br/>        "192.168.0.0/16"<br/>    ]<br/><br/>    "443" = [<br/>        "192.168.0.0/16"<br/>    ]<br/>} | <pre>map(<br/>    set(string)<br/>  )</pre> | `{}` | no |
| <a name="input_default_variables"></a> [default\_variables](#input\_default\_variables) | Default variables<br/><br/>* account\_name - Name of the desired AWS account<br/>* account\_id - ID of the desired AWS account<br/>* region - AWS region (defaults "eu-north-1")<br/><br/>* project - Project resource belongs to<br/>* purpose - Purpose of the resource. E.g. "upload-images" (defaults "")<br/>* env - The environment name<br/><br/>* owner - Name of the owner deployed services to belong to (defaults "devops")<br/><br/>* management\_account\_id - Management Account of the AWS Organization (defaults "760950667285") | <pre>object({<br/>    cloud        = string<br/>    account_name = optional(string)<br/>    account_id   = optional(string)<br/>    region       = optional(string, "eu-north-1")<br/><br/>    project = string<br/>    env     = string<br/>    purpose = optional(string, "")<br/><br/>    owner = string<br/><br/>    global_hosted_zone    = string<br/>    management_account_id = string<br/>    platform_account_id   = string<br/>    organization          = string<br/>    email_domain          = string<br/><br/>    infrastructure_repository = string<br/>    terragrunt_config = object(<br/>      {<br/>        stack_name    = optional(string, "")<br/>        stack_version = optional(string, "")<br/>      }<br/>    )<br/>  })</pre> | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The name of the CloudFlare zone<br/><br/>Example:<br/>* domain\_name = "example.org" | `string` | n/a | yes |
| <a name="input_image"></a> [image](#input\_image) | The image ID or name (defaults "ubuntu-22.04")<br/><br/>Example:<br/>* image = "ubuntu-22.04" | `string` | `"ubuntu-24.04"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | The number of servers (defaults 0)<br/><br/>Example:<br/>* instance\_count = 2 | `number` | `0` | no |
| <a name="input_instance_ids"></a> [instance\_ids](#input\_instance\_ids) | Alternative to server count ids (defaults [])<br/><br/>If provided will create servers based on provided list of values.<br/><br/>Example:<br/>* instance\_ids = [<br/>  "first",<br/>  "second",<br/>  "3"<br/>] | `set(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Components of the name<br/><br/>* purpose: Purpose of the resource. E.g. "upload-images"<br/>* separator: Name separator (defaults "-")<br/><br/>Resource name will be <project>-<env>-<purpose>-(\|<type of resource>)<br/><br/>Example:<br/>* name = {<br/>  purpose = "upload-images"<br/>  separator = "\_"<br/>} | <pre>object({<br/>    purpose   = optional(string, "")<br/>    separator = optional(string, "-")<br/>  })</pre> | <pre>{<br/>  "purpose": "",<br/>  "separator": "-"<br/>}</pre> | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | The unique slug that identifies the type of Server (defaults "cax11")<br/><br/>Available options:<br/>* "cpx[1-5]1" Shared AMD64<br/>* "cax[1-4]1" Shared ARM64<br/>* "ccx[1-6]3" Dedicated AMD64<br/>* "cx[2-5]2" Shared x86\_64<br/>More details: https://www.vpsbenchmarks.com/instance_types/hetzner<br/><br/>Example:<br/>* node\_type = "cpx11" | `string` | `"cax11"` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Authentication to CloudFlare, HCloud<br/><br/>Example:<br/>secrets = {<br/>  hcloud\_token = "SecretSecret"<br/>  cf\_api\_token = "SecretSecret"<br/>} | <pre>object({<br/>    hcloud_token = string<br/>    cf_api_token = string<br/>  })</pre> | n/a | yes |
| <a name="input_ssh_keys"></a> [ssh\_keys](#input\_ssh\_keys) | The list of ssh keys for server access (defaults [])<br/><br/>Example:<br/>* ssh\_keys = [<br/>  "12:34:45:65:df:ds:3f:2s:14:sx:qw:er:ty:yu:ui:fg"<br/>] | `list(string)` | `[]` | no |
| <a name="input_subdomain"></a> [subdomain](#input\_subdomain) | The subdomain of application (defaults "")<br/><br/>Example:<br/>* subdomain = "api" | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of the custom resource tags (defaults {})<br/><br/>Example:<br/>* tags = {<br/>  Foo = "Bar"<br/>} | `map(string)` | `{}` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | The size of the volume that will be attached to servers (defaults 0)<br/><br/>Example:<br/>* volume\_size = 64 | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domains"></a> [domains](#output\_domains) | List of created domains |
| <a name="output_servers"></a> [servers](#output\_servers) | List of created servers |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 5.9.0 |
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | 1.52.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_dns_record.dns_record](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [hcloud_firewall.this](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall) | resource |
| [hcloud_firewall_attachment.this](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall_attachment) | resource |
| [hcloud_server.this](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server) | resource |
| [hcloud_volume.this](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/volume) | resource |
| [hcloud_volume_attachment.this](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/volume_attachment) | resource |
| [cloudflare_zone.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zone) | data source |
| [hcloud_datacenters.this](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/data-sources/datacenters) | data source |
<!-- END_TF_DOCS -->
