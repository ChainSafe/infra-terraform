# external-secrets

<!-- BEGIN_TF_DOCS -->


# Terraform
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 2.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | ~> 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster<br/><br/>If not provided will use account name<br/><br/>Example:<br/>* cluster\_name = "dev" | `string` | `""` | no |
| <a name="input_default_variables"></a> [default\_variables](#input\_default\_variables) | Default variables<br/><br/>* account\_name - Name of the desired AWS account<br/>* account\_id - ID of the desired AWS account<br/>* region - AWS region (defaults "eu-north-1")<br/><br/>* project - Project resource belongs to<br/>* purpose - Purpose of the resource. E.g. "upload-images" (defaults "")<br/>* env - The environment name<br/><br/>* owner - Name of the owner deployed services to belong to (defaults "devops")<br/><br/>* management\_account\_id - Management Account of the AWS Organization (defaults "760950667285") | <pre>object({<br/>    cloud        = string<br/>    account_name = optional(string)<br/>    account_id   = optional(string)<br/>    region       = optional(string, "eu-north-1")<br/><br/>    project = string<br/>    env     = string<br/>    purpose = optional(string, "")<br/><br/>    owner = string<br/><br/>    global_hosted_zone    = string<br/>    management_account_id = string<br/>    platform_account_id   = string<br/>    organization          = string<br/>    email_domain          = string<br/><br/>    infrastructure_repository = string<br/>    terragrunt_config = object(<br/>      {<br/>        stack_name    = optional(string, "")<br/>        stack_version = optional(string, "")<br/>      }<br/>    )<br/>  })</pre> | n/a | yes |
| <a name="input_external_secrets_version"></a> [external\_secrets\_version](#input\_external\_secrets\_version) | Version of external-secrets/external-secrets chart (defaults "0.19.2")<br/><br/>https://github.com/external-secrets/external-secrets/blob/main/deploy/charts/external-secrets/Chart.yaml<br/><br/>Example:<br/>* external\_secrets\_version = "0.9.0" | `string` | `"0.19.2"` | no |
| <a name="input_name"></a> [name](#input\_name) | Components of the name<br/><br/>* purpose: Purpose of the resource. E.g. "upload-images"<br/>* separator: Name separator (defaults "-")<br/><br/>Resource name will be <project>-<env>-<purpose>-(\|<type of resource>)<br/><br/>Example:<br/>* name = {<br/>  purpose = "upload-images"<br/>  separator = "\_"<br/>} | <pre>object({<br/>    purpose   = optional(string, "")<br/>    separator = optional(string, "-")<br/>  })</pre> | <pre>{<br/>  "purpose": "",<br/>  "separator": "-"<br/>}</pre> | no |
| <a name="input_secrets_reloader_version"></a> [secrets\_reloader\_version](#input\_secrets\_reloader\_version) | Version of stakater/reloader chart (defaults "2.2.2")<br/><br/>https://github.com/stakater/Reloader/blob/master/deployments/kubernetes/chart/reloader/Chart.yaml<br/><br/>Example:<br/>* secrets\_reloader\_version = "1.2.2" | `string` | `"2.2.2"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of the custom resource tags (defaults {})<br/><br/>Example:<br/>* tags = {<br/>  Foo = "Bar"<br/>} | `map(string)` | `{}` | no |

## Outputs

No outputs.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.12.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 3.0.2 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.38.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 5.2.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.external_secrets](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.reloader](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.external_secrets](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret_v1.external_secrets](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [vault_auth_backend.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/auth_backend) | resource |
| [vault_kubernetes_auth_backend_config.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kubernetes_auth_backend_config) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [kubernetes_service_account_v1.external_secrets](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service_account_v1) | data source |
<!-- END_TF_DOCS -->
