locals {
  oncall_users = [
    for member in var.team_members :
    [
      for user in data.grafana_oncall_users.this.users :
      user.id
      if user.username == member
    ]
  ]

  oncall_managers = toset([
    for user in data.grafana_oncall_users.this.users :
    user.id
    if contains(var.team_managers, user.username)
  ])
}
