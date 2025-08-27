resource "kubernetes_storage_class_v1" "gp3" {
  metadata {
    name = "gp3"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner    = "ebs.csi.aws.com"
  reclaim_policy         = "Delete"
  allow_volume_expansion = true
  volume_binding_mode    = "WaitForFirstConsumer"

  parameters = {
    type      = "gp3"
    encrypted = true
  }
}

resource "kubernetes_storage_class_v1" "efs" {
  metadata {
    name = "efs"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "false"
    }
  }

  storage_provisioner = "efs.csi.aws.com"
  reclaim_policy      = "Delete"
  mount_options       = ["tls"]
  volume_binding_mode = "Immediate"
  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId     = aws_efs_file_system.efs_driver.id
    directoryPerms   = "700"
    gidRangeStart    = "1000"
    gidRangeEnd      = "7000000"
  }
}
