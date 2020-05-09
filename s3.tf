resource "aws_s3_bucket" "bucket" {
  bucket        = var.s3_bucket_name
  acl           = "public-read"

  website {
    index_document = var.index_document
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}