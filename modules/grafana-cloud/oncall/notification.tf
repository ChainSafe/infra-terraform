# resource "grafana_mute_timing" "weekends" {
#   name = "${var.team_name}-weekeneds"
#
#   intervals {
#     weekdays = ["saturday", "sunday"]
#   }
# }
#
# resource "grafana_mute_timing" "working_hours" {
#   name = "${var.team_name}-working-hours"
#   intervals {
#     times {
#       start = "09:00"
#       end   = "18:00"
#     }
#   }
# }

# resource "grafana_notification_policy" "this" {
#   contact_point = grafana_contact_point.this.name
#
#   group_by        = ["severity"]
#   group_wait      = "45s"
#   group_interval  = "6m"
#   repeat_interval = "3h"
#
#   policy {
#     matcher {
#       label = "project_name"
#       match = "="
#       value = var.project_name
#     }
#     matcher {
#       label = "severity"
#       match = "="
#       value = "warning"
#     }
#     group_by = ["instance"]
#     mute_timings = [
#       grafana_mute_timing.weekends.name
#     ]
#     active_timings = [
#       grafana_mute_timing.working_hours.name
#     ]
#   }
#
#   policy {
#     matcher {
#       label = "project_name"
#       match = "="
#       value = var.project_name
#     }
#     matcher {
#       label = "severity"
#       match = "="
#       value = "critical"
#     }
#     group_by = ["instance"]
#   }
# }
