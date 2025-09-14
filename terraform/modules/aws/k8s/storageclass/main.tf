terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      configuration_aliases = [kubernetes.eks]
    }
    helm = {
      source = "hashicorp/helm"
      configuration_aliases = [helm.eks]
    }
  }
}

resource "helm_release" "ebs_csi_driver" {
  provider   = helm.eks
  name       = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  namespace  = "kube-system"

  set {
    name  = "controller.replicaCount"
    value = 1
  }

  set {
    name  = "controller.resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "controller.resources.requests.cpu"
    value = "100m"
  }
}

resource "kubernetes_storage_class" "this" {
  provider = kubernetes.eks
  metadata {
    name = var.name
  }

  storage_provisioner = "ebs.csi.aws.com"

  parameters = {
    type = var.volume_type
  }

  reclaim_policy      = "Delete"
  volume_binding_mode = "WaitForFirstConsumer"

  depends_on = [helm_release.ebs_csi_driver]
}
