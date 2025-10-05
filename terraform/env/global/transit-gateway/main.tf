data "terraform_remote_state" "eu" {
  backend = "s3"
  config = {
    bucket = "toni-bootstrap-tfstate-us-east-1"
    key    = "eu-west-1/dev/infra/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "us" {
  backend = "s3"
  config = {
    bucket = "toni-bootstrap-tfstate-us-east-1"
    key    = "us-east-1/dev/infra/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "asia" {
  backend = "s3"
  config = {
    bucket = "toni-bootstrap-tfstate-us-east-1"
    key    = "ap-northeast-1/dev/infra/terraform.tfstate"
    region = "us-east-1"
  }
}

module "transit_gateway" {
  source      = "../../../../modules/aws/transit-gateway"
  name        = "tgw-hub-eu"
  description = "Transit Gateway global para EU/US/ASIA"
  tags        = { Env = "global", Project = "multi-vpc" }

  vpc_map = {
    eu = {
      vpc_id             = data.terraform_remote_state.eu.outputs.vpc_id
      private_subnet_ids = data.terraform_remote_state.eu.outputs.private_subnet_ids
    }
    us = {
      vpc_id             = data.terraform_remote_state.us.outputs.vpc_id
      private_subnet_ids = data.terraform_remote_state.us.outputs.private_subnet_ids
    }
    asia = {
      vpc_id             = data.terraform_remote_state.asia.outputs.vpc_id
      private_subnet_ids = data.terraform_remote_state.asia.outputs.private_subnet_ids
    }
  }
}
