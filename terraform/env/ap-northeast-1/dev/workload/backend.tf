terraform {
  backend "s3" {
    bucket         = "toni-bootstrap-tfstate-ap-northeast-1"
    key            = "ap-northeast-1/dev/workload/terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
