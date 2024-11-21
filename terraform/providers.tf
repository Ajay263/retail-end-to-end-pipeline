terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  
  # Configure S3 backend for state management
  backend "s3" {
    bucket         = "topdevs-terraform-state"
    key            = "projects/retail-end-to-end-pipeline/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = var.aws_region
}
