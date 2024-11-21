# modules/iam/variables.tf
variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "ingestion_bucket_arn" {
  description = "ARN of the ingestion S3 bucket"
  type        = string
}

variable "data_lake_bucket_arn" {
  description = "ARN of the data lake S3 bucket"
  type        = string
}

