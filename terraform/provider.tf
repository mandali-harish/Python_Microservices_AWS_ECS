terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
    backend "s3" {
    bucket         = "harishmandali-tfstate-bucket"
    key            = "terraform/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "harishmandali-tfstate-locking"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}