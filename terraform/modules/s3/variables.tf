variable "api_ingestion_bucket_name" {
  description = "Name of the S3 bucket for API data ingestion"
  type        = string
  default     = "retail-database"
}

variable "data_lake_bucket_name" {
  description = "Name of the S3 bucket for Data Lake storage"
  type        = string
  default     = "retail-datalake"
}
