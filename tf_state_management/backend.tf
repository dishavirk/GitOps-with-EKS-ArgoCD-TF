terraform {
  backend "s3" {
    bucket = "my-tf01-state"
    key    = "eks/terraform.tfstate"
    region = "eu-west-1"
   }
}
