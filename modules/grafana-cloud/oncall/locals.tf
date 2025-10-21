locals {
  oncall_users = toset([
    for user in data.grafana_oncall_users.this.users :
    user.id
    if contains(var.team_members, user.username)
  ])

  oncall_managers = toset([
    for user in data.grafana_oncall_users.this.users :
    user.id
    if contains(var.team_managers, user.username)
  ])
}
