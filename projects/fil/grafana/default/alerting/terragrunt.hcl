# ---------------------------------------------------------------------------------------------------------------------
# You can find latest template for this module at:
# https://github.com/ChainSafe/infra-terraform/tree/main/modules/grafana-cloud/alerting/examples/
# ---------------------------------------------------------------------------------------------------------------------

locals {
  stack_name    = "modules/grafana-cloud/alerting"
  stack_version = "main" # FIXME: Please update version if required

  stack_host       = "git::git@github.com"
  stack_repository = "ChainSafe/infra-terraform"
}

# Terragrunt will copy the Terraform configurations specified by the source
# parameter, along with any files in the working directory,
# into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${local.stack_host}:${local.stack_repository}.git//${local.stack_name}?ref=${local.stack_version}"
}

include "root" {
  path = find_in_parent_folders("terragrunt-core.hcl")
}


# TODO: These are the variables we have to pass in to use the module specified in the terragrunt configuration above:
inputs = {
  # ---------------------------------------------------------------------------------------------------------------------
  # Components of the name
  #
  # * purpose: Purpose of the resource. E.g. "upload-images"
  # * separator: Name separator (defaults "-")
  #
  # Resource name will be <project>-<env>-<purpose>-(|<type of resource>)
  #
  # Example:
  # * name = {
  #   purpose = "upload-images"
  #   separator = "_"
  # }
  # ---------------------------------------------------------------------------------------------------------------------
  # name = {
  #   purpose = ""
  #   separator = "-"
  # }

  # ---------------------------------------------------------------------------------------------------------------------
  # Map of the custom resource tags (defaults {})
  #
  # Example:
  # * tags = {
  #   Foo = "Bar"
  # }
  # ---------------------------------------------------------------------------------------------------------------------
  # tags = {}

  # ---------------------------------------------------------------------------------------------------------------------
  # List of files local to the project with dashboards (defaults [])
  #
  # Example:
  # * dashboards = [
  #   "./dashboards/example.json"
  # ]
  # ---------------------------------------------------------------------------------------------------------------------
  dashboards = [
    "./dashboards/forest.json",
    "./dashboards/forest-snapshots-node-dashboard.json",
    "./dashboards/lotus.json",
    "./dashboards/filecoin-snapshot.json"
  ]

  # ---------------------------------------------------------------------------------------------------------------------
  # Configuration of Grafana Cloud Alert rules (defaults {})
  #
  # Example:
  # * alerts = {
  #   "FilecoinSnapshotAgeOld" = {
  #     expr = "probe_snapshot_age_minutes > 240"
  #     title = "The Latest Filecoin Snapshot is older Than 120 minutes"
  #     for_duration = "5m"
  #     datasource_uid = "grafanacloud-prom"
  #     is_critical = true
  #     labels = {}
  #     annotations = {
  #       description = "The Latest Filecoin {{ $labels.network }} Snapshot is older than 120 minutes (2 hours), current age is {{ $values.A.Value }} minutes."
  #       summary     = "The Latest Filecoin Snapshot is older Than 120 minutes"
  #     }
  #   }
  # }
  # ---------------------------------------------------------------------------------------------------------------------
  # alerts = {}

  # ---------------------------------------------------------------------------------------------------------------------
  # Prometheus/Alertmanager rules file (defaults "")
  #
  # If provided alert rules would be generated from the file
  #
  # Example:
  # * alerts_file = "./alerts.yaml"
  # ---------------------------------------------------------------------------------------------------------------------
  alerts_file = "./alerts.yaml"

  # ---------------------------------------------------------------------------------------------------------------------
  # Name of default PagerDuty escalation policy
  #
  # Example:
  # * pd_escalation_policy = "test"
  # ---------------------------------------------------------------------------------------------------------------------
  pd_escalation_policy = "Adobrodey-test" # "infra-ep"
}
