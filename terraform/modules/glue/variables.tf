# modules/glue/variables.tf
variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "glue_role_arn" {
  description = "ARN of the Glue IAM role"
  type        = string
}

variable "script_bucket" {
  description = "S3 bucket containing Glue job script"
  type        = string
}

variable "script_key" {
  description = "S3 key for Glue job script"
  type        = string
  default     = "glue/data_transformation.py"
}

variable "ingestion_bucket" {
  description = "S3 bucket for data ingestion"
  type        = string
}

variable "data_lake_bucket" {
  description = "S3 bucket for data lake storage"
  type        = string
}

