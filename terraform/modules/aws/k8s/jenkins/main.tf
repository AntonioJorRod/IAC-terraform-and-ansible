provider "kubernetes" {
  alias                  = "eks"
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  alias = "eks"
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}

resource "kubernetes_namespace" "this" {
  provider = kubernetes.eks
  metadata { name = var.namespace }
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
