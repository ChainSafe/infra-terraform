# karpenter

<!-- BEGIN_TF_DOCS -->


# Terraform
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster<br/><br/>Example:<br/>* eks\_cluster\_name = "dev" | `string` | `""` | no |
| <a name="input_default_variables"></a> [default\_variables](#input\_default\_variables) | Default variables<br/><br/>* account\_name - Name of the desired AWS account<br/>* account\_id - ID of the desired AWS account<br/>* region - AWS region (defaults "eu-north-1")<br/><br/>* project - Project resource belongs to<br/>* purpose - Purpose of the resource. E.g. "upload-images" (defaults "")<br/>* env - The environment name<br/><br/>* owner - Name of the owner deployed services to belong to (defaults "devops")<br/><br/>* management\_account\_id - Management Account of the AWS Organization (defaults "760950667285") | <pre>object({<br/>    account_name = string<br/>    account_id   = string<br/>    region       = optional(string, "eu-north-1")<br/><br/>    project = string<br/>    purpose = optional(string, "")<br/>    env     = string<br/><br/>    owner = optional(string, "devops")<br/><br/>    management_account_id = optional(string, "760950667285")<br/>  })</pre> | n/a | yes |
| <a name="input_karpenter_version"></a> [karpenter\_version](#input\_karpenter\_version) | Version of karpenter/karpenter (defaults "1.6.1")<br/><br/>https://gallery.ecr.aws/karpenter/karpenter<br/><br/>Example:<br/>* karpenter\_version = "1.7.0" | `string` | `"1.6.1"` | no |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | Configuration of the additional node groups (defaults {})<br/><br/>Options:<br/>* max\_cpu - Maximum number of CPU for the Node Group (defaults 20)<br/>* class - Node Class, one of "bottlerocket" or "al2023" (defaults "bottlerocket")<br/>* hypervisor - AWS instance hypervisor (defaults "nitro")<br/>* family - List of instance families (defaults ["m6"])<br/>* cpu - List of CPU options (defaults [4])<br/>* is\_spot - If the instance is Spot (defaults true)<br/><br/>More details:<br/>https://aws.amazon.com/ec2/instance-types/<br/><br/>Example:<br/>* node\_groups = {<br/>  cpu\_optimized = {<br/>    max\_cpu = 30<br/>    family = ["c5"]<br/>    cpu = [4, 8]<br/>    is\_spot = false<br/>  }<br/>} | <pre>map(<br/>    object(<br/>      {<br/>        max_cpu    = optional(number, 20)<br/>        class      = optional(string, "bottlerocket")<br/>        hypervisor = optional(string, "nitro")<br/>        family     = optional(set(string), ["m6"])<br/>        cpu        = optional(set(number), [4])<br/>        is_spot    = optional(bool, true)<br/>      }<br/>    )<br/>  )</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of the custom resource tags (defaults {})<br/><br/>Example:<br/>* tags = {<br/>  Foo = "Bar"<br/>} | `map(string)` | `{}` | no |

## Outputs

No outputs.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.10.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 3.0.2 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 2.1.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_karpenter"></a> [karpenter](#module\_karpenter) | terraform-aws-modules/eks/aws//modules/karpenter | ~> v21.0 |

## Resources

| Name | Type |
|------|------|
| [helm_release.karpenter](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.karpenter_crds](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.karpenter_node_class](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.karpenter_node_pool](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_role.eks_node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
<!-- END_TF_DOCS -->
