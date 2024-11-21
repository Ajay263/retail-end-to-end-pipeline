# modules/s3/variables.tf
variable "api_ingestion_bucket_name" {
  description = "Name of the S3 bucket for API data ingestion"
  type        = string
}

variable "data_lake_bucket_name" {
  description = "Name of the S3 bucket for Data Lake storage"
  type        = string
}

