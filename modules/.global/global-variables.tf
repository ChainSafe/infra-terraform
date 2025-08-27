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
    account_name = string
    account_id   = string
    region       = optional(string, "eu-north-1")

    project = string
    purpose = optional(string, "")
    env     = string

    owner = optional(string, "devops")

    management_account_id = optional(string, "760950667285")
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
