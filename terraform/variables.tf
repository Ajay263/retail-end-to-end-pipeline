# variables.tf
variable "aws_region" {
  description = "AWS region for the infrastructure"
  type        = string
  default     = "eu-north-1"
}

variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Name of the data pipeline project"
  type        = string
  default     = "retail-end-to-end-pipeline"
}

variable "api_ingestion_bucket_name" {
  description = "S3 bucket for API data ingestion"
  type        = string
}

variable "data_lake_bucket_name" {
  description = "S3 bucket for Data Lake storage"
  type        = string
}