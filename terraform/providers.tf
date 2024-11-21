terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }



terraform {
  backend "s3" {
    bucket         = "topdevs-terraform-state"
    key            = "terraform/state"
    region         = "eu-north-1"
    dynamodb_table = "terraform-state-locks"
  }
}
  


provider "aws" {
  region = var.aws_region
}
