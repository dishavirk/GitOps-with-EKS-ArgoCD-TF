output "bucket_name" {
  value       = var.create_bucket ? aws_s3_bucket.terraform_state[0].bucket : ""
  description = "The name of the bucket used for storing Terraform state"
}
