terraform {
  backend "s3" {
    bucket         = "toni-bootstrap-tfstate-us-east-1"
    key            = "us-east-1/dev/workload/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
