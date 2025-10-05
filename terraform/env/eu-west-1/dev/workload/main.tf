# Jenkins config
# Implementation of ebs-csi-driver - Non used, we use helm cause this plugins enable 2 replicas and we want only 1
# module "ebs_csi_driver_west" {
#   source = "../../../../modules/aws/eks-addons/ebs-csi-driver"
#
#   cluster_name       = module.eks_west.cluster_name
#   oidc_provider_arn  = module.eks_oidc_west.arn
#   oidc_provider_url  = module.eks_west.cluster_identity_oidc
# }

module "storageclass_west" {
  source = "../../../../modules/aws/k8s/ebs-csi-driver"

  name        = "gp3"
  volume_type = "gp3"

  providers = {
    kubernetes.eks = kubernetes.eks_west
    helm.eks       = helm.eks_west
  }
}

module "jenkins_west" {
  source        = "../../../../modules/aws/k8s/jenkins"
  namespace     = var.namespace
  release_name  = var.release_name
  chart_version = var.chart_version
  region        = "eu-west-1"

  cluster_endpoint       = data.terraform_remote_state.infra_west.outputs.cluster_endpoint_west
  cluster_ca_certificate = data.terraform_remote_state.infra_west.outputs.cluster_certificate_west
  cluster_name           = data.terraform_remote_state.infra_west.outputs.cluster_name_west
  aws_auth_ready         = data.terraform_remote_state.infra_west.outputs.aws_auth_ready_west

  providers = {
    kubernetes.eks = kubernetes.eks_west
    helm.eks       = helm.eks_west
  }
}

module "secrets_operators_west" {
  source = "../../../modules/k8s/operators/secrets-operators"
  region = "eu-west-1"
}
