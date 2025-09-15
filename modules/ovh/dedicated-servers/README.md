# dedicated-servers

<!-- BEGIN_TF_DOCS -->


# Terraform
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 5.0 |
| <a name="requirement_ovh"></a> [ovh](#requirement\_ovh) | ~> 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_configuration"></a> [configuration](#input\_configuration) | Configuration of Servers<br/><br/>Available options:<br/>* os - https://ca.api.ovh.com/v1/dedicated/installationTemplate<br/>* ssh - AWX public key<br/>* script - Post installation script<br/><br/>Example:<br/>* configuration = {<br/>  os = "ubuntu2404-server\_64"<br/><br/>  script = <<-SCRIPT<br/>  #!/bin/bash<br/>  hostnamectl set-hostname ${hostname}<br/>  SCRIPT<br/>} | <pre>object({<br/>    os      = optional(string, "ubuntu2404-server_64")<br/>    ssh_key = optional(string, "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQdyDPqu80ZSimqReNHZhHN7xTSK4CXTHjI2nZlQ911 awx@chainsafe.io")<br/>    script = optional(string,<br/>      <<-SCRIPT<br/>      #!/bin/bash<br/>      apt update<br/>      apt install -y ansible git wget<br/><br/>      git clone "https://github.com/ChainSafe/fil-ansible-collection" /tmp/bootstrap<br/>      ansible-playbook -i localhost, -c local /tmp/bootstrap/bootstrap.yml<br/>      SCRIPT<br/>    )<br/>    monitoring   = optional(bool, true)<br/>    intervention = optional(bool, true)<br/>  })</pre> | <pre>{<br/>  "intervention": true,<br/>  "monitoring": true,<br/>  "os": "ubuntu2404-server_64",<br/>  "script": "#!/bin/bash\napt update\napt install -y ansible git wget\n\ngit clone \"https://github.com/ChainSafe/fil-ansible-collection.git\" /tmp/bootstrap\nansible-playbook -i localhost, -c local /tmp/bootstrap/bootstrap.yml\n",<br/>  "ssh_key": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQdyDPqu80ZSimqReNHZhHN7xTSK4CXTHjI2nZlQ911 awx@chainsafe.io"<br/>}</pre> | no |
| <a name="input_default_variables"></a> [default\_variables](#input\_default\_variables) | Default variables<br/><br/>* account\_name - Name of the desired AWS account<br/>* account\_id - ID of the desired AWS account<br/>* region - AWS region (defaults "eu-north-1")<br/><br/>* project - Project resource belongs to<br/>* purpose - Purpose of the resource. E.g. "upload-images" (defaults "")<br/>* env - The environment name<br/><br/>* owner - Name of the owner deployed services to belong to (defaults "devops")<br/><br/>* management\_account\_id - Management Account of the AWS Organization (defaults "760950667285") | <pre>object({<br/>    cloud        = string<br/>    account_name = optional(string)<br/>    account_id   = optional(string)<br/>    region       = optional(string, "eu-north-1")<br/><br/>    project = string<br/>    env     = string<br/>    purpose = optional(string, "")<br/><br/>    owner = string<br/><br/>    global_hosted_zone    = string<br/>    management_account_id = string<br/>    platform_account_id   = string<br/>    organization          = string<br/>    email_domain          = string<br/><br/>    infrastructure_repository = string<br/>    terragrunt_config = object(<br/>      {<br/>        stack_name    = optional(string, "")<br/>        stack_version = optional(string, "")<br/>      }<br/>    )<br/>  })</pre> | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The name of the zone (defaults null)<br/><br/>Example:<br/>* domain\_name = "example.org" | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Components of the name<br/><br/>* purpose: Purpose of the resource. E.g. "upload-images"<br/>* separator: Name separator (defaults "-")<br/><br/>Resource name will be <project>-<env>-<purpose>-(\|<type of resource>)<br/><br/>Example:<br/>* name = {<br/>  purpose = "upload-images"<br/>  separator = "\_"<br/>} | <pre>object({<br/>    purpose   = optional(string, "")<br/>    separator = optional(string, "-")<br/>  })</pre> | <pre>{<br/>  "purpose": "",<br/>  "separator": "-"<br/>}</pre> | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Authentication to CloudFlare, OVHCloud<br/><br/>Example:<br/>secrets = {<br/>  ovh\_endpoint = "ovh-ca"<br/>  ovh\_app\_key = "SecretKey"<br/>  ovh\_app\_secret = "SecretSecret"<br/>  ovh\_consumer\_key = "SecretConsumerKey"<br/>  cf\_api\_token = "SecretSecret"<br/>} | <pre>object({<br/>    ovh_endpoint     = optional(string, "ovh-ca")<br/>    ovh_app_key      = string<br/>    ovh_app_secret   = string<br/>    ovh_consumer_key = string<br/>    cf_api_token     = string<br/>  })</pre> | n/a | yes |
| <a name="input_servers"></a> [servers](#input\_servers) | Dedicate Server IDs and names for configuration (defaults {})<br/><br/><br/>Example:<br/>* servers = {<br/>  "nsxxxxxxx.ip-xx-xx-xx.eu" = "api-foo-back"<br/>} | `map(string)` | `{}` | no |
| <a name="input_subdomain"></a> [subdomain](#input\_subdomain) | The subdomain of application (defaults "")<br/><br/>Example:<br/>* subdomain = "api" | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of the custom resource tags (defaults {})<br/><br/>Example:<br/>* tags = {<br/>  Foo = "Bar"<br/>} | `map(string)` | `{}` | no |

## Outputs

No outputs.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 5.9.0 |
| <a name="provider_ovh"></a> [ovh](#provider\_ovh) | 2.7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_dns_record.dns_record](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [ovh_dedicated_server.this](https://registry.terraform.io/providers/ovh/ovh/latest/docs/resources/dedicated_server) | resource |
| [cloudflare_zone.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zone) | data source |
| [ovh_dedicated_installation_template.this](https://registry.terraform.io/providers/ovh/ovh/latest/docs/data-sources/dedicated_installation_template) | data source |
| [ovh_me.this](https://registry.terraform.io/providers/ovh/ovh/latest/docs/data-sources/me) | data source |
<!-- END_TF_DOCS -->
