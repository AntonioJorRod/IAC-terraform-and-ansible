provider "aws" {
  region = "ap-northeast-1"
  alias  = "ap-northeast-1"
}

# Debemos leer aqui con Data tfstate en los otros es meramente data por que el modulo eks vive en infra
# aqui eks viva en tfstate por lo que es data.tfstate
data "terraform_remote_state" "infra_west" {
  backend = "s3"  
  config = {
    bucket = "toni-bootstrap-tfstate-us-east-1"
    key    = "ap-northeast-1/dev/infra/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_eks_cluster_auth" "this_west" {
  name = data.terraform_remote_state.infra_west.outputs.cluster_name_west
}

provider "kubernetes" {
  alias                  = "eks_west"
  host                   = data.terraform_remote_state.infra_west.outputs.cluster_endpoint_west
  cluster_ca_certificate = base64decode(data.terraform_remote_state.infra_west.outputs.cluster_certificate_west)
  token                  = data.aws_eks_cluster_auth.this_west.token
}

provider "helm" {
  alias = "eks_west"
  kubernetes {
    host                   = data.terraform_remote_state.infra_west.outputs.cluster_endpoint_west
    cluster_ca_certificate = base64decode(data.terraform_remote_state.infra_west.outputs.cluster_certificate_west)
    token                  = data.aws_eks_cluster_auth.this_west.token
  }
}
