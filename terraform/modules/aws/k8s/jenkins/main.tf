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

resource "kubernetes_namespace" "this" {
  provider = kubernetes.eks
  metadata {
    name = var.namespace
  }
  depends_on = [var.aws_auth_ready]
}

resource "helm_release" "this" {
  provider   = helm.eks
  name       = var.release_name
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = var.chart_version
  namespace  = kubernetes_namespace.this.metadata[0].name
  values     = [file("${path.module}/values.yaml")]
  depends_on = [kubernetes_namespace.this]
}
