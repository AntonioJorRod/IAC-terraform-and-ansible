terraform {
  backend "s3" {
    bucket         = "toni-bootstrap-tfstate-eu-west-1"
    key            = "eu-west-1/dev/workload/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
