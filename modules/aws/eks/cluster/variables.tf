variable "cluster_name" {
  type        = string
  description = <<DESC
Name of the EKS cluster (defaults "")

If not provided will use account name

Example:
* cluster_name = "dev"
DESC
  default     = ""
}

variable "kubernetes_version" {
  type        = string
  description = <<DESC
Target version of the Kubernetes cluster (defaults "1.33")

Example:
* kubernetes_version = "1.19"
DESC
  default     = "1.33"
}

variable "default_node_group" {
  type = object(
    {
      instance_types = optional(set(string), ["m6g.large"])
      min_capacity   = optional(number, 2)
      max_capacity   = optional(number, 3)
    }
  )

  description = <<DESC
Default nodes configuration (defaults {instance_types=["m6g.large"],min_capacity=2,max_capacity=3})

Example:
* default_node_group = {
    instance_types = ["m5.large"]
    min_capacity   = 2
    max_capacity   = 3
}
DESC

  default = {
    instance_types = ["m6g.large"]
    min_capacity   = 2
    max_capacity   = 3
  }
}

variable "api_access_cidrs" {
  type = set(string)

  description = <<DESC
Access CIDRs to Cluster API (defaults ["10.0.0.0/8"])

Example:
* api_access_cidrs = [
  "192.168.1.0/24"
]
DESC

  default = [
    "10.0.0.0/8"
  ]
}

variable "enabled_log_types" {
  type = list(string)

  description = <<DESC
List of enabled CW logs (defaults ["authenticator"])

Available options:
* "api"
* "audit"
* "authenticator"
* "controllerManager"
* "scheduler"

Example:
* eks_enabled_log_types = [
  "api",
  "authenticator",
  "controllerManager",
]
DESC

  default = [
    "audit",
    "authenticator",
  ]
}

variable "eks_map_roles" {
  type = map(
    object(
      {
        groups   = list(string)
        is_admin = optional(bool, false)
      }
    )
  )

  description = <<DESC
Map of IAM roles with access to K8s API (defaults {})

Example:
* eks_map_roles = {
  "arn:aws:iam::01234567890:role/Developers" = {
    groups = [
      "developers"
    ]
  }
}
DESC

  default = {}
}

variable "subnet_types" {
  type = object({
    vpc_name           = optional(string, "")
    nodes              = optional(string, "private")
    control_plane      = optional(string, "internal")
    availability_zones = optional(set(string), ["a", "b", "c"])
  })

  description = <<DESC
Configuration of subnets for nodes/control plane(defaults {nodes="private",control_plane="internal",availability_zones=["a","b","c"]})

Example:
* subnet_types = {
  control_plane = "private"
}
DESC

  default = {
    vpc_name           = ""
    nodes              = "private"
    control_plane      = "internal"
    availability_zones = ["a", "b", "c"]
  }
}
