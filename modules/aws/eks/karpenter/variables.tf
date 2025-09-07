variable "cluster_name" {
  type = string

  description = <<DESC
Name of the EKS cluster

Example:
* cluster_name = "dev"
DESC

  default = ""
}

# https://gallery.ecr.aws/karpenter/karpenter
variable "karpenter_version" {
  type        = string
  description = <<DESC
Version of karpenter/karpenter (defaults "1.6.3")

https://gallery.ecr.aws/karpenter/karpenter

Example:
* karpenter_version = "1.7.0"
DESC
  default     = "1.6.3"
}

variable "node_groups" {
  type = map(
    object(
      {
        max_cpu    = optional(number, 20)
        class      = optional(string, "bottlerocket")
        hypervisor = optional(string, "nitro")
        family     = optional(set(string), ["m6"])
        cpu        = optional(set(number), [4])
        is_spot    = optional(bool, true)
        tainted    = optional(bool, false)
      }
    )
  )

  description = <<DESC
Configuration of the additional node groups (defaults {})

Options:
* max_cpu - Maximum number of CPU for the Node Group (defaults 20)
* class - Node Class, one of "bottlerocket" or "al2023" (defaults "bottlerocket")
* hypervisor - AWS instance hypervisor (defaults "nitro")
* family - List of instance families (defaults ["m6"])
* cpu - List of CPU options (defaults [4])
* is_spot - If the instance is Spot (defaults true)
* tainted - If the node is Tainted by default (defaults false)

More details:
https://aws.amazon.com/ec2/instance-types/

Example:
* node_groups = {
  cpu_optimized = {
    max_cpu = 30
    family = ["c5"]
    cpu = [4, 8]
    is_spot = false
    tainted = true
  }
}
DESC
  default     = {}
}
