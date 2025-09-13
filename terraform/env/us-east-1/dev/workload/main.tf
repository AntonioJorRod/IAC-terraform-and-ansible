# Jenkins config
module "storageclass" {
  source = "../../../../modules/aws/k8s/storageclass"

  name        = "gp3"
  volume_type = "gp3"

  providers = {
    kubernetes = kubernetes.eks
  }
}

module "jenkins" {
  source        = "../../../../modules/aws/k8s/jenkins"
  namespace     = "jenkins"
  release_name  = "jenkins"
  chart_version = "4.7.0"

  cluster_endpoint       = data.terraform_remote_state.infra.outputs.cluster_endpoint
  cluster_ca_certificate = data.terraform_remote_state.infra.outputs.cluster_certificate
  cluster_name           = data.terraform_remote_state.infra.outputs.cluster_name
  aws_auth_ready         = data.terraform_remote_state.infra.outputs.aws_auth_ready

  providers = {
    kubernetes = kubernetes.eks
    helm       = helm.eks
  }
}
