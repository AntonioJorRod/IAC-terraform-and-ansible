resource "kubernetes_storage_class" "this" {
  metadata {
    name = var.name
  }

  storage_provisioner = "ebs.csi.aws.com"

  parameters = {
    type = var.volume_type
  }

  reclaim_policy      = "Delete"
  volume_binding_mode = "WaitForFirstConsumer"
}
