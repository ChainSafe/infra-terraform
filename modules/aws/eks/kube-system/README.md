# kube-system

<!-- BEGIN_TF_DOCS -->


# Terraform
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.13.1 |
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
| <a name="input_default_variables"></a> [default\_variables](#input\_default\_variables) | Default variables<br/><br/>* account\_name - Name of the desired AWS account<br/>* account\_id - ID of the desired AWS account<br/>* region - AWS region (defaults "eu-north-1")<br/><br/>* project - Project resource belongs to<br/>* purpose - Purpose of the resource. E.g. "upload-images" (defaults "")<br/>* env - The environment name<br/><br/>* owner - Name of the owner deployed services to belong to (defaults "devops")<br/><br/>* management\_account\_id - Management Account of the AWS Organization (defaults "760950667285") | <pre>object({<br/>    account_name = string<br/>    account_id   = string<br/>    region       = optional(string, "eu-north-1")<br/><br/>    project = string<br/>    purpose = optional(string, "")<br/>    env     = string<br/><br/>    owner = optional(string, "devops")<br/><br/>    management_account_id = optional(string, "760950667285")<br/>  })</pre> | n/a | yes |
| <a name="input_enable_public_external_dns"></a> [enable\_public\_external\_dns](#input\_enable\_public\_external\_dns) | Enable Public External DNS(defaults false)<br/><br/>Example:<br/>* enable\_public\_external\_dns = true | `bool` | `false` | no |
| <a name="input_external_dns_version"></a> [external\_dns\_version](#input\_external\_dns\_version) | Version of bitnami/external-dns (defaults "8.7.7")<br/><br/>https://github.com/bitnami/charts/tree/main/bitnami/external-dns/Chart.yaml<br/><br/>Example:<br/>* external\_dns\_version = "2.20.0" | `string` | `"8.7.7"` | no |
| <a name="input_ingress_nginx_version"></a> [ingress\_nginx\_version](#input\_ingress\_nginx\_version) | Version of ingress-nginx/ingress-nginx (defaults "4.12.1")<br/><br/>https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/Chart.yaml<br/><br/>Example:<br/>* ingress\_nginx\_version = "4.12.1" | `string` | `"4.12.1"` | no |
| <a name="input_keda_version"></a> [keda\_version](#input\_keda\_version) | Version of kedacore/keda (defaults "2.16.1")<br/><br/>https://github.com/kedacore/charts/blob/main/keda/Chart.yaml<br/><br/>Example:<br/>* keda\_version = "2.20.0" | `string` | `"2.16.1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of the custom resource tags (defaults {})<br/><br/>Example:<br/>* tags = {<br/>  Foo = "Bar"<br/>} | `map(string)` | `{}` | no |
| <a name="input_volume_autoscaler_version"></a> [volume\_autoscaler\_version](#input\_volume\_autoscaler\_version) | Version of devops-nirvana/volume-autoscaler (defaults "1.0.8")<br/><br/>https://github.com/DevOps-Nirvana/Kubernetes-Volume-Autoscaler/blob/master/helm-chart/Chart.yaml<br/><br/>Example:<br/>* volume\_autoscaler\_version = "1.7.0" | `string` | `"1.0.8"` | no |

## Outputs

No outputs.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.10.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 3.0.2 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 2.1.3 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.38.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_efs_file_system.efs_driver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.efs_driver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_eks_pod_identity_association.keda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_pod_identity_association) | resource |
| [aws_iam_role.aws_alb_ingress_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.keda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.aws_alb_ingress_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.keda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_security_group.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [helm_release.alb_ingress](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.external_dns](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.ingress_nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.keda](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.crds](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace_v1.external_dns](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_secret_v1.external_dns](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [kubernetes_storage_class_v1.efs](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class_v1) | resource |
| [kubernetes_storage_class_v1.gp3](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class_v1) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.assume_keda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.aws_alb_ingress_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.keda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_security_group.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [kubernetes_all_namespaces.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/all_namespaces) | data source |
<!-- END_TF_DOCS -->
