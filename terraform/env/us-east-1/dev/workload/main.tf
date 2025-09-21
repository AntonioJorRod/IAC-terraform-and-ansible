# Jenkins config
# Implementation of ebs-csi-driver - Non used, we use helm cause this plugins enable 2 replicas and we want only 1
# module "ebs_csi_driver" {
#   source = "../../../../modules/aws/eks-addons/ebs-csi-driver"
#
#   cluster_name       = module.eks.cluster_name
#   oidc_provider_arn  = module.eks_oidc.arn
#   oidc_provider_url  = module.eks.cluster_identity_oidc
# }

module "storageclass" {
  source = "../../../../modules/aws/k8s/storageclass"

  name        = "gp3"
  volume_type = "gp3"

  providers = {
    kubernetes.eks = kubernetes.eks
    helm.eks       = helm.eks
  }
}

module "jenkins" {
  source        = "../../../../modules/aws/k8s/jenkins"
  namespace     = var.namespace
  release_name  = var.release_name
  chart_version = var.chart_version
  region        = var.region

  cluster_endpoint       = data.terraform_remote_state.infra.outputs.cluster_endpoint
  cluster_ca_certificate = data.terraform_remote_state.infra.outputs.cluster_certificate
  cluster_name           = data.terraform_remote_state.infra.outputs.cluster_name
  aws_auth_ready         = data.terraform_remote_state.infra.outputs.aws_auth_ready

  providers = {
    kubernetes.eks = kubernetes.eks
    helm.eks       = helm.eks
  }
}

module "secrets_operators" {
  source = "../../../modules/k8s/operators/secrets-operators"
  region = var.region
}
