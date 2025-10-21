variable "team_name" {
  type        = string
  description = <<DESC
Name of the on-call team

Example:
* team_name = "devops"
DESC
}

variable "team_members" {
  type = list(string)

  description = <<DESC
List of on-call users (defaults [])

Example:
* team_members = [
  "adobrodey"
]
DESC

  default = []
}

variable "team_managers" {
  type = set(string)

  description = <<DESC
List of team managers (defaults [])

Example:
* team_managers = [
  "joshdougall"
]
DESC

  default = []
}

variable "time_zone" {
  type = string

  description = <<DESC
Timezone of the on-call rotation (defaults "UTC")

Example:
* time_zone = "Europe/Berlin"
DESC

  default = "UTC"
}
