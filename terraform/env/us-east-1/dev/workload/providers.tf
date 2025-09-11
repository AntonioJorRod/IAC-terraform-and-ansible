provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
}

data "terraform_remote_state" "infra" {
  backend = "s3"
  config = {
    bucket = "toni-bootstrap-tfstate-us-east-1"
    key    = "dev/infra/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "kubernetes" {
  alias                  = "eks"
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  alias = "eks"
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}
