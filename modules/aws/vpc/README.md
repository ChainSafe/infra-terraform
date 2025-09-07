# vpc

<!-- BEGIN_TF_DOCS -->
# AWS VPC module

Create vpc and subnets.

# Terraform
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attach_tgws"></a> [attach\_tgws](#input\_attach\_tgws) | List of TGWs to attach (defaults [])<br/><br/>Expects RAM with tgw names<br/><br/>Example:<br/>* attach\_tgws = ["example-tgw"] | `set(string)` | `[]` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of letters of the availability zones in desired region (defaults ["a", "b", "c"])<br/><br/>Example:<br/>* availability\_zones = [ "c", "d"] | `list(string)` | <pre>[<br/>  "a",<br/>  "b",<br/>  "c"<br/>]</pre> | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | The CIDR blocks for the VPC<br/><br/>Allowed subnets from /16 till /22.<br/><br/>Variable allows to configure any CIDRs for the subnets, by default will:<br/>* dedicate half of the IP pool to private subnets<br/>* dedicate 1/8 of the pool to public, internal, database subnets and spread across AZs<br/>If operator provides custom subnet CIDRs he is responsible to ensure that subnets are independent.<br/><br/>Example:<br/>* cidr = "10.92.0.0/20" | <pre>object({<br/>    vpc                   = string<br/>    secondary_cidr_blocks = optional(list(string), [])<br/>    public_subnets        = optional(list(string), [])<br/>    private_subnets       = optional(list(string), [])<br/>    internal_subnets      = optional(list(string), [])<br/>    database_subnets      = optional(list(string), [])<br/>  })</pre> | n/a | yes |
| <a name="input_company_networks"></a> [company\_networks](#input\_company\_networks) | List of Company network (defaults ["10.0.0.0/8"])<br/><br/>Default security groups allow HTTPS access from defined networks.<br/><br/>Example:<br/>* company\_networks = [<br/>  "1.2.3.4/20",<br/>] | `set(string)` | <pre>[<br/>  "10.0.0.0/8"<br/>]</pre> | no |
| <a name="input_create_database_subnets"></a> [create\_database\_subnets](#input\_create\_database\_subnets) | If the subnets for the RDS will be created (defaults false)<br/><br/>Typical scenario is subnets for RDS instances<br/><br/>Example:<br/>* create\_database\_subnets = true | `bool` | `false` | no |
| <a name="input_create_internal_subnets"></a> [create\_internal\_subnets](#input\_create\_internal\_subnets) | If the subnets without access to internet will be created (defaults false)<br/><br/>Typical scenario is subnets for EKS control plane instances<br/><br/>Example:<br/>* create\_internal\_subnets = true | `bool` | `false` | no |
| <a name="input_default_variables"></a> [default\_variables](#input\_default\_variables) | Default variables<br/><br/>* account\_name - Name of the desired AWS account<br/>* account\_id - ID of the desired AWS account<br/>* region - AWS region (defaults "eu-north-1")<br/><br/>* project - Project resource belongs to<br/>* purpose - Purpose of the resource. E.g. "upload-images" (defaults "")<br/>* env - The environment name<br/><br/>* owner - Name of the owner deployed services to belong to (defaults "devops")<br/><br/>* management\_account\_id - Management Account of the AWS Organization (defaults "760950667285") | <pre>object({<br/>    cloud        = string<br/>    account_name = optional(string)<br/>    account_id   = optional(string)<br/>    region       = optional(string, "eu-north-1")<br/><br/>    project = string<br/>    env     = string<br/>    purpose = optional(string, "")<br/><br/>    owner = string<br/><br/>    global_hosted_zone    = string<br/>    management_account_id = string<br/>    platform_account_id   = string<br/>    organization          = string<br/>    email_domain          = string<br/><br/>    infrastructure_repository = string<br/>    terragrunt_config = object(<br/>      {<br/>        stack_name    = optional(string, "")<br/>        stack_version = optional(string, "")<br/>      }<br/>    )<br/>  })</pre> | n/a | yes |
| <a name="input_elastic_ips"></a> [elastic\_ips](#input\_elastic\_ips) | List of elastic IP names to configure (defaults [])<br/><br/>Example:<br/>* elastic\_ips = [<br/>  "example-ip"<br/>] | `set(string)` | `[]` | no |
| <a name="input_endpoint_services"></a> [endpoint\_services](#input\_endpoint\_services) | Map of vpc endpoint services (defaults to example)<br/><br/>* service\_name - Name of the service, if not provided will find from the key.<br/>* service\_type - Type of the service: Gateway, GatewayLoadBalancer, or Interface. Defaults "Gateway"<br/>* private\_dns -  Whether or not to associate a private hosted zone with the specified VPC. Defaults false.<br/>* multi\_az - Whether to create an endpoint per availability zone. Defaults false<br/>* subnet\_types - List of subnet types to associate with. If specified will take precedence over subnets\_tiers Defaults []<br/>* use\_default\_security\_group - Whether or not to use the default security group with VPC endpoint services. Defaults false<br/><br/>Example:<br/>* endpoint\_services = {<br/>  s3 = {<br/>    service\_type = "Gateway"<br/>  }<br/>  sts = {<br/>    service\_type = "Interface"<br/>  }<br/>} | <pre>map(object({<br/>    service_name               = optional(string, "")<br/>    service_type               = optional(string, "Gateway")<br/>    private_dns                = optional(bool, false)<br/>    multi_az                   = optional(bool, false)<br/>    subnet_types               = optional(list(string), [])<br/>    use_default_security_group = optional(bool, false)<br/>  }))</pre> | <pre>{<br/>  "s3": {<br/>    "service_type": "Gateway"<br/>  }<br/>}</pre> | no |
| <a name="input_manage_default_security_group"></a> [manage\_default\_security\_group](#input\_manage\_default\_security\_group) | If default security group will be managed (defaults true)<br/><br/>Example:<br/>* manage\_default\_security\_group = false | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Components of the name<br/><br/>* purpose: Purpose of the resource. E.g. "upload-images"<br/>* separator: Name separator (defaults "-")<br/><br/>Resource name will be <project>-<env>-<purpose>-(\|<type of resource>)<br/><br/>Example:<br/>* name = {<br/>  purpose = "upload-images"<br/>  separator = "\_"<br/>} | <pre>object({<br/>    purpose   = optional(string, "")<br/>    separator = optional(string, "-")<br/>  })</pre> | <pre>{<br/>  "purpose": "",<br/>  "separator": "-"<br/>}</pre> | no |
| <a name="input_single_nat"></a> [single\_nat](#input\_single\_nat) | If single NAT or NAT per AZ to create (defaults true)<br/><br/>Example:<br/>* single\_nat = false | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of the custom resource tags (defaults {})<br/><br/>Example:<br/>* tags = {<br/>  Foo = "Bar"<br/>} | `map(string)` | `{}` | no |
| <a name="input_vgw"></a> [vgw](#input\_vgw) | Configuration of VGW (defaults {asn=0,networks={}}) | <pre>object({<br/>    asn      = optional(number, 0)<br/>    networks = optional(map(string), {})<br/>  })</pre> | <pre>{<br/>  "asn": 0,<br/>  "networks": {}<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | The name of the VPC |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | The ARN of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.10.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_endpoints"></a> [endpoints](#module\_endpoints) | terraform-aws-modules/vpc/aws//modules/vpc-endpoints | 5.14.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 6.0.1 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_security_group.web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.web_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.web_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.web_http_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.web_https_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.web_public_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.web_public_http_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.web_public_https_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
<!-- END_TF_DOCS -->
