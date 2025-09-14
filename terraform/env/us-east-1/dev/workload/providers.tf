provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
}

# Debemos leer aqui con Data tfstate en los otros es meramente data por que el modulo eks vive en infra
# aqui eks viva en tfstate por lo que es data.tfstate
data "terraform_remote_state" "infra" {
  backend = "s3"  
  config = {
    bucket = "toni-bootstrap-tfstate-us-east-1"
    key    = "dev/infra/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_eks_cluster_auth" "this" {
  name = data.terraform_remote_state.infra.outputs.cluster_name
}

provider "kubernetes" {
  alias                  = "eks"
  host                   = data.terraform_remote_state.infra.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.infra.outputs.cluster_certificate)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  alias = "eks"
  kubernetes {
    host                   = data.terraform_remote_state.infra.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.infra.outputs.cluster_certificate)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}