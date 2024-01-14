variable "aws_region" {
  description = "AWS region where the S3 bucket will be created"
  type        = string
  default     = "eu-west-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket for storing Terraform state"
  type        = string
  default     = "my-tf01-state"
}

variable "create_bucket" {
  description = "Boolean to control whether the S3 bucket should be created"
  type        = bool
  default     = true
}



