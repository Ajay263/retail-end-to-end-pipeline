# modules/s3/main.tf .
resource "aws_s3_bucket" "ingestion_bucket" {
  bucket = var.api_ingestion_bucket_name
  
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket" "data_lake_bucket" {
  bucket = var.data_lake_bucket_name
  
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "ingestion_bucket_access" {
  bucket = aws_s3_bucket.ingestion_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "data_lake_bucket_access" {
  bucket = aws_s3_bucket.data_lake_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "ingestion_bucket_versioning" {
  bucket = aws_s3_bucket.ingestion_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "data_lake_bucket_versioning" {
  bucket = aws_s3_bucket.data_lake_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


