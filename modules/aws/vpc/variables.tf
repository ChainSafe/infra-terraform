variable "cidr" {
  type = object({
    vpc                   = string
    secondary_cidr_blocks = optional(list(string), [])
    public_subnets        = optional(list(string), [])
    private_subnets       = optional(list(string), [])
    internal_subnets      = optional(list(string), [])
    database_subnets      = optional(list(string), [])
  })
  description = <<DESC
The CIDR blocks for the VPC

Allowed subnets from /16 till /22.

Variable allows to configure any CIDRs for the subnets, by default will:
* dedicate half of the IP pool to private subnets
* dedicate 1/8 of the pool to public, internal, database subnets and spread across AZs
If operator provides custom subnet CIDRs he is responsible to ensure that subnets are independent.

Example:
* cidr = "10.92.0.0/20"
DESC

  validation {
    condition     = can(cidrnetmask(var.cidr.vpc))
    error_message = "IP cidr is not valid."
  }
}

variable "availability_zones" {
  type = list(string)

  description = <<DESC
List of letters of the availability zones in desired region (defaults ["a", "b", "c"])

Example:
* availability_zones = [ "c", "d"]
DESC

  default = [
    "a",
    "b",
    "c"
  ]
}

variable "create_internal_subnets" {
  type        = bool
  description = <<DESC
If the subnets without access to internet will be created (defaults false)

Typical scenario is subnets for EKS control plane instances

Example:
* create_internal_subnets = true
DESC

  default = false
}

variable "create_database_subnets" {
  type        = bool
  description = <<DESC
If the subnets for the RDS will be created (defaults false)

Typical scenario is subnets for RDS instances

Example:
* create_database_subnets = true
DESC

  default = false
}

variable "manage_default_security_group" {
  type        = bool
  description = <<DESC
If default security group will be managed (defaults true)

Example:
* manage_default_security_group = false
DESC

  default = true
}

variable "endpoint_services" {
  type = map(object({
    service_name               = optional(string, "")
    service_type               = optional(string, "Gateway")
    private_dns                = optional(bool, false)
    multi_az                   = optional(bool, false)
    subnet_types               = optional(list(string), [])
    use_default_security_group = optional(bool, false)
  }))

  description = <<DESC
Map of vpc endpoint services (defaults to example)

* service_name - Name of the service, if not provided will find from the key.
* service_type - Type of the service: Gateway, GatewayLoadBalancer, or Interface. Defaults "Gateway"
* private_dns -  Whether or not to associate a private hosted zone with the specified VPC. Defaults false.
* multi_az - Whether to create an endpoint per availability zone. Defaults false
* subnet_types - List of subnet types to associate with. If specified will take precedence over subnets_tiers Defaults []
* use_default_security_group - Whether or not to use the default security group with VPC endpoint services. Defaults false

Example:
* endpoint_services = {
  s3 = {
    service_type = "Gateway"
  }
  sts = {
    service_type = "Interface"
  }
}
DESC

  default = {
    s3 = {
      service_type = "Gateway"
    }
  }
}

variable "company_networks" {
  type        = set(string)
  description = <<DESC
List of Company network (defaults ["10.0.0.0/8"])

Default security groups allow HTTPS access from defined networks.

Example:
* company_networks = [
  "1.2.3.4/20",
]
DESC
  default = [
    "10.0.0.0/8"
  ]
}

variable "vgw" {
  type = object({
    asn      = optional(number, 0)
    networks = optional(map(string), {})
  })

  description = <<DESC
Configuration of VGW (defaults {asn=0,networks={}})
DESC

  default = {
    asn      = 0
    networks = {}
  }
}

variable "transit_gw_owner" {
  type        = string
  description = <<DESC
ID Of the account containing TGW (defaults null)

Example:
* transit_gw_owner = "1234567890"
DESC
  default     = null
}

variable "attach_tgws" {
  type = set(string)

  description = <<DESC
List of TGWs to attach (defaults [])

Expects RAM with tgw names

Example:
* attach_tgws = ["example-tgw"]
DESC

  default = []
}

variable "elastic_ips" {
  type = set(string)

  description = <<DESC
List of elastic IP names to configure (defaults [])

Example:
* elastic_ips = [
  "example-ip"
]
DESC

  default = []
}
