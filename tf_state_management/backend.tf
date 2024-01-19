terraform {
  backend "s3" {
    bucket = "my-tfv1-state"
    key    = "eks/terraform.tfstate"
    region = "eu-west-1"
   }
}
