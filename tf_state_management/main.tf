resource "aws_s3_bucket" "terraform_state" {
  count  = var.create_bucket ? 1 : 0
  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Terraform Backend"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  count = var.create_bucket ? 1 : 0
  bucket = aws_s3_bucket.terraform_state[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  count = var.create_bucket ? 1 : 0
  bucket = aws_s3_bucket.terraform_state[0].id

  rule {
    id     = "lifecycle_rule"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
