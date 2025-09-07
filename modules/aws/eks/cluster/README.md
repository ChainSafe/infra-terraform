# cluster

<!-- BEGIN_TF_DOCS -->


# Terraform
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_access_cidrs"></a> [api\_access\_cidrs](#input\_api\_access\_cidrs) | Access CIDRs to Cluster API (defaults ["10.0.0.0/8"])<br/><br/>Example:<br/>* api\_access\_cidrs = [<br/>  "192.168.1.0/24"<br/>] | `set(string)` | <pre>[<br/>  "10.0.0.0/8"<br/>]</pre> | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster (defaults "")<br/><br/>If not provided will use account name<br/><br/>Example:<br/>* cluster\_name = "dev" | `string` | `""` | no |
| <a name="input_default_node_group"></a> [default\_node\_group](#input\_default\_node\_group) | Default nodes configuration (defaults {instance\_types=["m6g.large"],min\_capacity=2,max\_capacity=3})<br/><br/>If node group is tainted, it allows only CriticalAddons installation<br/><br/>Example:<br/>* default\_node\_group = {<br/>    instance\_types = ["m5.large"]<br/>    min\_capacity   = 2<br/>    max\_capacity   = 3<br/>    tainted = true<br/>} | <pre>object(<br/>    {<br/>      instance_types = optional(set(string), ["m6g.large"])<br/>      min_capacity   = optional(number, 2)<br/>      max_capacity   = optional(number, 3)<br/>      tainted        = optional(bool, false)<br/>    }<br/>  )</pre> | <pre>{<br/>  "instance_types": [<br/>    "m6g.large"<br/>  ],<br/>  "max_capacity": 3,<br/>  "min_capacity": 2,<br/>  "tainted": false<br/>}</pre> | no |
| <a name="input_default_variables"></a> [default\_variables](#input\_default\_variables) | Default variables<br/><br/>* account\_name - Name of the desired AWS account<br/>* account\_id - ID of the desired AWS account<br/>* region - AWS region (defaults "eu-north-1")<br/><br/>* project - Project resource belongs to<br/>* purpose - Purpose of the resource. E.g. "upload-images" (defaults "")<br/>* env - The environment name<br/><br/>* owner - Name of the owner deployed services to belong to (defaults "devops")<br/><br/>* management\_account\_id - Management Account of the AWS Organization (defaults "760950667285") | <pre>object({<br/>    cloud        = string<br/>    account_name = optional(string)<br/>    account_id   = optional(string)<br/>    region       = optional(string, "eu-north-1")<br/><br/>    project = string<br/>    env     = string<br/>    purpose = optional(string, "")<br/><br/>    owner = string<br/><br/>    global_hosted_zone    = string<br/>    management_account_id = string<br/>    platform_account_id   = string<br/>    organization          = string<br/>    email_domain          = string<br/><br/>    infrastructure_repository = string<br/>    terragrunt_config = object(<br/>      {<br/>        stack_name    = optional(string, "")<br/>        stack_version = optional(string, "")<br/>      }<br/>    )<br/>  })</pre> | n/a | yes |
| <a name="input_eks_map_roles"></a> [eks\_map\_roles](#input\_eks\_map\_roles) | Map of IAM roles with access to K8s API (defaults {})<br/><br/>Example:<br/>* eks\_map\_roles = {<br/>  "arn:aws:iam::01234567890:role/Developers" = {<br/>    groups = [<br/>      "developers"<br/>    ]<br/>  }<br/>} | <pre>map(<br/>    object(<br/>      {<br/>        groups   = list(string)<br/>        is_admin = optional(bool, false)<br/>      }<br/>    )<br/>  )</pre> | `{}` | no |
| <a name="input_enabled_log_types"></a> [enabled\_log\_types](#input\_enabled\_log\_types) | List of enabled CW logs (defaults ["authenticator"])<br/><br/>Available options:<br/>* "api"<br/>* "audit"<br/>* "authenticator"<br/>* "controllerManager"<br/>* "scheduler"<br/><br/>Example:<br/>* eks\_enabled\_log\_types = [<br/>  "api",<br/>  "authenticator",<br/>  "controllerManager",<br/>] | `list(string)` | <pre>[<br/>  "audit",<br/>  "authenticator"<br/>]</pre> | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Target version of the Kubernetes cluster (defaults "1.33")<br/><br/>Example:<br/>* kubernetes\_version = "1.19" | `string` | `"1.33"` | no |
| <a name="input_name"></a> [name](#input\_name) | Components of the name<br/><br/>* purpose: Purpose of the resource. E.g. "upload-images"<br/>* separator: Name separator (defaults "-")<br/><br/>Resource name will be <project>-<env>-<purpose>-(\|<type of resource>)<br/><br/>Example:<br/>* name = {<br/>  purpose = "upload-images"<br/>  separator = "\_"<br/>} | <pre>object({<br/>    purpose   = optional(string, "")<br/>    separator = optional(string, "-")<br/>  })</pre> | <pre>{<br/>  "purpose": "",<br/>  "separator": "-"<br/>}</pre> | no |
| <a name="input_subnet_types"></a> [subnet\_types](#input\_subnet\_types) | Configuration of subnets for nodes/control plane(defaults {nodes="private",control\_plane="internal",availability\_zones=["a","b","c"]})<br/><br/>Example:<br/>* subnet\_types = {<br/>  control\_plane = "private"<br/>} | <pre>object({<br/>    vpc_name           = optional(string, "")<br/>    nodes              = optional(string, "private")<br/>    control_plane      = optional(string, "internal")<br/>    availability_zones = optional(set(string), ["a", "b", "c"])<br/>  })</pre> | <pre>{<br/>  "availability_zones": [<br/>    "a",<br/>    "b",<br/>    "c"<br/>  ],<br/>  "control_plane": "internal",<br/>  "nodes": "private",<br/>  "vpc_name": ""<br/>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of the custom resource tags (defaults {})<br/><br/>Example:<br/>* tags = {<br/>  Foo = "Bar"<br/>} | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the cluster |
| <a name="output_node_iam_role_arn"></a> [node\_iam\_role\_arn](#output\_node\_iam\_role\_arn) | ARN of the managed Nodes IAM Role |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.11.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> v21.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_tag.subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_eks_access_entry.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_entry) | resource |
| [aws_eks_access_policy_association.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_policy_association) | resource |
| [aws_iam_role.ebs_csi_irsa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.efs_csi_irsa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.eks_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.vpc_cni_irsa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ebs_csi_irsa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.efs_csi_irsa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.vpc_cni_irsa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.ephemeral_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ebs_csi_irsa_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.efs_csi_irsa_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eks_managed_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vpc_cni_irsa_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_roles.administrators](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_roles) | data source |
| [aws_organizations_organization.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_security_group.web_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnet.control_plane](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.control_plane](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
<!-- END_TF_DOCS -->
