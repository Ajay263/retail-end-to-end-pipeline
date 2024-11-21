# modules/s3/outputs.tf
output "ingestion_bucket_id" {
  value = aws_s3_bucket.ingestion_bucket.id
}

output "data_lake_bucket_id" {
  value = aws_s3_bucket.data_lake_bucket.id
}