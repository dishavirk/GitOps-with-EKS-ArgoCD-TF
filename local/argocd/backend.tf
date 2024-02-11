terraform {
  backend "s3" {
    bucket = "my-tfv1-state"
    key    = "argocd/terraform.tfstate"
    region = "eu-west-1"
  }
}
