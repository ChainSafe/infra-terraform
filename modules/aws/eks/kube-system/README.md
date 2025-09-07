# kube-system

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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_controller_version"></a> [alb\_controller\_version](#input\_alb\_controller\_version) | Version of eks/aws-load-balancer-controller (defaults "1.13.4")<br/><br/>https://github.com/aws/eks-charts/tree/master/stable/aws-load-balancer-controller/Chart.yaml<br/><br/>Example:<br/>* alb\_controller\_version = "0.1.12" | `string` | `"1.13.4"` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | Version of jetstack/cert-manager (defaults "1.18.2")<br/><br/>https://artifacthub.io/packages/helm/cert-manager/cert-manager?modal=values<br/><br/>Example:<br/>* cert\_manager\_version = "1.7.0" | `string` | `"1.18.2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster<br/><br/>If not provided will use account name<br/><br/>Example:<br/>* cluster\_name = "dev" | `string` | `""` | no |
| <a name="input_default_variables"></a> [default\_variables](#input\_default\_variables) | Default variables<br/><br/>* account\_name - Name of the desired AWS account<br/>* account\_id - ID of the desired AWS account<br/>* region - AWS region (defaults "eu-north-1")<br/><br/>* project - Project resource belongs to<br/>* purpose - Purpose of the resource. E.g. "upload-images" (defaults "")<br/>* env - The environment name<br/><br/>* owner - Name of the owner deployed services to belong to (defaults "devops")<br/><br/>* management\_account\_id - Management Account of the AWS Organization (defaults "760950667285") | <pre>object({<br/>    cloud        = string<br/>    account_name = optional(string)<br/>    account_id   = optional(string)<br/>    region       = optional(string, "eu-north-1")<br/><br/>    project = string<br/>    env     = string<br/>    purpose = optional(string, "")<br/><br/>    owner = string<br/><br/>    global_hosted_zone    = string<br/>    management_account_id = string<br/>    platform_account_id   = string<br/>    organization          = string<br/>    email_domain          = string<br/><br/>    infrastructure_repository = string<br/>    terragrunt_config = object(<br/>      {<br/>        stack_name    = optional(string, "")<br/>        stack_version = optional(string, "")<br/>      }<br/>    )<br/>  })</pre> | n/a | yes |
| <a name="input_external_dns_version"></a> [external\_dns\_version](#input\_external\_dns\_version) | Version of bitnami/external-dns (defaults "9.0.3")<br/><br/>https://github.com/bitnami/charts/tree/main/bitnami/external-dns/Chart.yaml<br/><br/>Example:<br/>* external\_dns\_version = "2.20.0" | `string` | `"9.0.3"` | no |
| <a name="input_ingress_nginx_version"></a> [ingress\_nginx\_version](#input\_ingress\_nginx\_version) | Version of ingress-nginx/ingress-nginx (defaults "4.13.2")<br/><br/>https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/Chart.yaml<br/><br/>Example:<br/>* ingress\_nginx\_version = "4.12.1" | `string` | `"4.13.2"` | no |
| <a name="input_keda_version"></a> [keda\_version](#input\_keda\_version) | Version of kedacore/keda (defaults "2.17.2")<br/><br/>https://github.com/kedacore/charts/blob/main/keda/Chart.yaml<br/><br/>Example:<br/>* keda\_version = "2.20.0" | `string` | `"2.17.2"` | no |
| <a name="input_name"></a> [name](#input\_name) | Components of the name<br/><br/>* purpose: Purpose of the resource. E.g. "upload-images"<br/>* separator: Name separator (defaults "-")<br/><br/>Resource name will be <project>-<env>-<purpose>-(\|<type of resource>)<br/><br/>Example:<br/>* name = {<br/>  purpose = "upload-images"<br/>  separator = "\_"<br/>} | <pre>object({<br/>    purpose   = optional(string, "")<br/>    separator = optional(string, "-")<br/>  })</pre> | <pre>{<br/>  "purpose": "",<br/>  "separator": "-"<br/>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of the custom resource tags (defaults {})<br/><br/>Example:<br/>* tags = {<br/>  Foo = "Bar"<br/>} | `map(string)` | `{}` | no |
| <a name="input_volume_autoscaler_version"></a> [volume\_autoscaler\_version](#input\_volume\_autoscaler\_version) | Version of devops-nirvana/volume-autoscaler (defaults "1.0.8")<br/><br/>https://github.com/DevOps-Nirvana/Kubernetes-Volume-Autoscaler/blob/master/helm-chart/Chart.yaml<br/><br/>Example:<br/>* volume\_autoscaler\_version = "1.7.0" | `string` | `"1.0.8"` | no |

## Outputs

No outputs.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.11.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 3.0.2 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 2.1.3 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.38.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.external_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_efs_file_system.efs_driver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.efs_driver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_eks_pod_identity_association.keda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_pod_identity_association) | resource |
| [aws_iam_role.aws_alb_ingress_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.external_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.keda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.aws_alb_ingress_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.external_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.keda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.external_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [helm_release.alb_ingress](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.external_dns](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.ingress_nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.keda](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.cert_issuers](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.crds](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.ingress_nginx](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace_v1.external_dns](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_storage_class_v1.efs](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class_v1) | resource |
| [kubernetes_storage_class_v1.gp3](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class_v1) | resource |
| [aws_acm_certificate.ingress_nginx](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.assume_external_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.assume_keda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.aws_alb_ingress_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.external_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.keda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_zone.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_security_group.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [kubernetes_all_namespaces.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/all_namespaces) | data source |
| [kubernetes_service_v1.ingress_nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service_v1) | data source |
<!-- END_TF_DOCS -->
