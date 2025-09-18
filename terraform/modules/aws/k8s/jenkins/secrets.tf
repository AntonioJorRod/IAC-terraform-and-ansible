resource "kubernetes_secret" "jenkins" {
  provider = kubernetes.eks

  metadata {
    name      = "jenkins-secrets"
    namespace = var.namespace
  }

  type = "Opaque"

  data = {
    AWS_SECRET_KEY = base64encode("valor-super-secreto-aws")
    GITHUB_USER    = base64encode("usuario-github")
    GITHUB_TOKEN   = base64encode("token-github")
    SLACK_TOKEN    = base64encode("token-slack")
  }
}

resource "kubernetes_config_map" "jenkins_jcasc" {
  provider = kubernetes.eks

  metadata {
    name      = "jenkins-jcasc"
    namespace = var.namespace
  }

  data = {
    "jenkins.yaml" = file("${path.module}/jenkins.yaml") # Aquí carga el archivo externo jenkins.yaml como ConfigMap
  }
}
