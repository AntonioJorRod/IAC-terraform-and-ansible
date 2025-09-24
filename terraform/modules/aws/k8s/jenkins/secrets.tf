resource "kubernetes_manifest" "jenkins_secrets" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ExternalSecret"
    metadata = {
      name      = "jenkins-secrets"
      namespace = var.namespace
    }
    spec = {
      refreshInterval = "1h"
      secretStoreRef = {
        name = "aws-ssm"
        kind = "ClusterSecretStore"
      }
      target = {
        name           = "jenkins-secrets"
        creationPolicy = "Owner"
      }
      data = [
        { secretKey = "GITHUB_USER",    remoteRef = { key = "/jenkins/github-user" } },
        { secretKey = "GITHUB_TOKEN",   remoteRef = { key = "/jenkins/github-token" } },
        { secretKey = "AWS_SECRET_KEY", remoteRef = { key = "/jenkins/aws-secret-key" } },
        { secretKey = "SLACK_TOKEN",    remoteRef = { key = "/jenkins/slack-token" } }
      ]
    }
  }
}
