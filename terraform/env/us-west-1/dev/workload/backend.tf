terraform {
  backend "s3" {
    bucket         = "toni-bootstrap-tfstate-us-west-1"
    key            = "us-west-1/dev/workload/terraform.tfstate"
    region         = "us-west-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
