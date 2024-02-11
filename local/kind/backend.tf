terraform {
  backend "s3" {
    bucket = "my-tfv1-state"
    key    = "kind/terraform.tfstate"
    region = "eu-west-1"
  }
}
