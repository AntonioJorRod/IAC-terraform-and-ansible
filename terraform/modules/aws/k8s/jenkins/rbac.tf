resource "kubernetes_role" "jenkins_prod_deployer" {
  metadata {
    name      = "jenkins-prod-deployer"
    namespace = "prod"
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "services", "configmaps", "secrets"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "statefulsets", "daemonsets", "replicasets"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
}

resource "kubernetes_role_binding" "jenkins_prod_deployer_binding" {
  metadata {
    name      = "jenkins-prod-deployer-binding"
    namespace = "prod"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.jenkins_prod_deployer.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = "jenkins"
    namespace = "jenkins"
  }
}
