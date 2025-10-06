terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
  }
}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

resource "helm_release" "keda" {
  name             = "keda"
  repository       = "https://kedacore.github.io/charts"
  chart            = "keda"
  namespace        = var.namespace
  create_namespace = true
  version          = var.keda_chart_version

  set {
    name  = "operator.logLevel"
    value = var.keda_log_level
  }

  set {
    name  = "watchNamespace"
    value = var.watch_namespace
  }
}
