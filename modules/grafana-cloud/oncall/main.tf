resource "grafana_oncall_escalation_chain" "critical" {
  name = "${var.team_name}-critical"

  team_id = data.grafana_oncall_team.this.id
}

resource "grafana_oncall_escalation_chain" "warning" {
  name = "${var.team_name}-warning"

  team_id = data.grafana_oncall_team.this.id
}

resource "grafana_oncall_escalation" "critical_on_call" {
  escalation_chain_id          = grafana_oncall_escalation_chain.critical.id
  type                         = "notify_on_call_from_schedule"
  important                    = true
  notify_on_call_from_schedule = grafana_oncall_schedule.this.id
  position                     = 0
}

resource "grafana_oncall_escalation" "critical_on_call_wait" {
  escalation_chain_id = grafana_oncall_escalation_chain.critical.id
  type                = "wait"
  duration            = 15 * 60 # 15 minutes
  position            = 1
}

resource "grafana_oncall_escalation" "critical_team" {
  escalation_chain_id    = grafana_oncall_escalation_chain.critical.id
  type                   = "notify_team_members"
  notify_to_team_members = data.grafana_oncall_team.this.id
  position               = 2
}

resource "grafana_oncall_escalation" "critical_team_wait" {
  escalation_chain_id = grafana_oncall_escalation_chain.critical.id
  type                = "wait"
  duration            = 30 * 60 # 30 minutes
  position            = 3
}

resource "grafana_oncall_escalation" "critical_manager" {
  escalation_chain_id = grafana_oncall_escalation_chain.critical.id
  type                = "notify_persons"
  important           = true
  persons_to_notify   = local.oncall_managers
  position            = 4
}

resource "grafana_oncall_escalation" "critical_manager_wait" {
  escalation_chain_id = grafana_oncall_escalation_chain.critical.id
  type                = "wait"
  duration            = 30 * 60 # 30 minutes
  position            = 5
}

resource "grafana_oncall_escalation" "critical_repeat" {
  escalation_chain_id = grafana_oncall_escalation_chain.critical.id
  type                = "repeat_escalation"
  position            = 6
}

resource "grafana_oncall_escalation" "warning_on_call" {
  escalation_chain_id          = grafana_oncall_escalation_chain.warning.id
  type                         = "notify_on_call_from_schedule"
  notify_on_call_from_schedule = grafana_oncall_schedule.this.id
  position                     = 0
}

resource "grafana_oncall_escalation" "warning_on_call_wait" {
  escalation_chain_id = grafana_oncall_escalation_chain.warning.id
  type                = "wait"
  duration            = 60 * 60 # 1 hour
  position            = 1
}

resource "grafana_oncall_escalation" "warning_team" {
  escalation_chain_id    = grafana_oncall_escalation_chain.warning.id
  type                   = "notify_team_members"
  notify_to_team_members = data.grafana_oncall_team.this.id
  position               = 2
}

resource "grafana_oncall_escalation" "warning_team_wait" {
  escalation_chain_id = grafana_oncall_escalation_chain.warning.id
  type                = "wait"
  duration            = 4 * 60 * 60 # 4 hours
  position            = 3
}

resource "grafana_oncall_escalation" "warning_repeat" {
  escalation_chain_id = grafana_oncall_escalation_chain.warning.id
  type                = "repeat_escalation"
  position            = 4
}

resource "grafana_oncall_on_call_shift" "this" {
  name                           = var.team_name
  type                           = "rolling_users"
  start                          = "2025-10-20T07:00:00"
  time_zone                      = var.time_zone
  duration                       = 60 * 60 * 24 * 7 # 1 week
  frequency                      = "weekly"
  interval                       = 1
  week_start                     = "MO"
  start_rotation_from_user_index = 0
  team_id                        = data.grafana_oncall_team.this.id

  rolling_users = local.oncall_users
}

resource "grafana_oncall_schedule" "this" {
  name = var.team_name
  type = "calendar"

  team_id   = data.grafana_oncall_team.this.id
  time_zone = var.time_zone

  shifts = [
    grafana_oncall_on_call_shift.this.id
  ]
}
