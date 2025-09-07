variable "name" {
  type = object({
    purpose   = optional(string, "")
    separator = optional(string, "-")
  })

  description = <<DESC
Components of the name

* purpose: Purpose of the resource. E.g. "upload-images"
* separator: Name separator (defaults "-")

Resource name will be <project>-<env>-<purpose>-(|<type of resource>)

Example:
* name = {
  purpose = "upload-images"
  separator = "_"
}
DESC

  default = {
    purpose   = ""
    separator = "-"
  }
}

variable "tags" {
  type        = map(string)
  description = <<DESC
Map of the custom resource tags (defaults {})

Example:
* tags = {
  Foo = "Bar"
}
DESC
  default     = {}
}

variable "default_variables" {
  type = object({
    cloud        = string
    account_name = optional(string)
    account_id   = optional(string)
    region       = optional(string, "eu-north-1")

    project = string
    env     = string
    purpose = optional(string, "")

    owner = string

    global_hosted_zone    = string
    management_account_id = string
    platform_account_id   = string
    organization          = string
    email_domain          = string

    infrastructure_repository = string
    terragrunt_config = object(
      {
        stack_name    = optional(string, "")
        stack_version = optional(string, "")
      }
    )
  })

  description = <<DESC
Default variables

* account_name - Name of the desired AWS account
* account_id - ID of the desired AWS account
* region - AWS region (defaults "eu-north-1")

* project - Project resource belongs to
* purpose - Purpose of the resource. E.g. "upload-images" (defaults "")
* env - The environment name

* owner - Name of the owner deployed services to belong to (defaults "devops")

* management_account_id - Management Account of the AWS Organization (defaults "760950667285")
DESC
}
