# external-secrets

<!-- BEGIN_TF_DOCS -->


# Terraform
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | 5.2.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_variables"></a> [default\_variables](#input\_default\_variables) | Default variables<br/><br/>* account\_name - Name of the desired AWS account<br/>* account\_id - ID of the desired AWS account<br/>* region - AWS region (defaults "eu-north-1")<br/><br/>* project - Project resource belongs to<br/>* purpose - Purpose of the resource. E.g. "upload-images" (defaults "")<br/>* env - The environment name<br/><br/>* owner - Name of the owner deployed services to belong to (defaults "devops")<br/><br/>* management\_account\_id - Management Account of the AWS Organization (defaults "760950667285") | <pre>object({<br/>    account_name = string<br/>    account_id   = string<br/>    region       = optional(string, "eu-north-1")<br/><br/>    project = string<br/>    purpose = optional(string, "")<br/>    env     = string<br/><br/>    owner = optional(string, "devops")<br/><br/>    management_account_id = optional(string, "760950667285")<br/>  })</pre> | n/a | yes |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of the EKS cluster<br/><br/>If not provided will use account name<br/><br/>Example:<br/>* eks\_cluster\_name = "dev" | `string` | `""` | no |
| <a name="input_external_secrets_version"></a> [external\_secrets\_version](#input\_external\_secrets\_version) | Version of external-secrets/external-secrets chart (defaults "0.15.0")<br/><br/>https://github.com/external-secrets/external-secrets/blob/main/deploy/charts/external-secrets/Chart.yaml<br/><br/>Example:<br/>* external\_secrets\_version = "0.9.0" | `string` | `"0.15.0"` | no |
| <a name="input_secrets_reloader_version"></a> [secrets\_reloader\_version](#input\_secrets\_reloader\_version) | Version of stakater/reloader chart (defaults "2.0.0")<br/><br/>https://github.com/stakater/Reloader/blob/master/deployments/kubernetes/chart/reloader/Chart.yaml<br/><br/>Example:<br/>* secrets\_reloader\_version = "1.2.2" | `string` | `"2.0.0"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of the custom resource tags (defaults {})<br/><br/>Example:<br/>* tags = {<br/>  Foo = "Bar"<br/>} | `map(string)` | `{}` | no |

## Outputs

No outputs.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.10.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 3.0.2 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.38.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 5.2.1 |
| <a name="provider_vault.legacy"></a> [vault.legacy](#provider\_vault.legacy) | 5.2.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.external_secrets](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.reloader](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_cluster_role_binding_v1.external_secrets](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding_v1) | resource |
| [kubernetes_namespace.external_secrets](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret_v1.external_secrets](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [vault_auth_backend.legacy](https://registry.terraform.io/providers/hashicorp/vault/5.2.1/docs/resources/auth_backend) | resource |
| [vault_auth_backend.this](https://registry.terraform.io/providers/hashicorp/vault/5.2.1/docs/resources/auth_backend) | resource |
| [vault_kubernetes_auth_backend_config.legacy](https://registry.terraform.io/providers/hashicorp/vault/5.2.1/docs/resources/kubernetes_auth_backend_config) | resource |
| [vault_kubernetes_auth_backend_config.this](https://registry.terraform.io/providers/hashicorp/vault/5.2.1/docs/resources/kubernetes_auth_backend_config) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [kubernetes_service_account.external_secrets](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service_account) | data source |
<!-- END_TF_DOCS -->
