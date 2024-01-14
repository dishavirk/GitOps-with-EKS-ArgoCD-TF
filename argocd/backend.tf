terraform {
  backend "s3" {
    bucket = "my-tf01-state"
    key    = "argocd/terraform.tfstate"
    region = "eu-west-1"
  }
}
