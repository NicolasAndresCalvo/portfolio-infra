terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40"
    }
  }

  # Phase 2: switch to a remote S3 backend once you have a state bucket.
  # backend "s3" {
  #   bucket = "nicolasandrescalvo-tfstate"
  #   key    = "portfolio-site/terraform.tfstate"
  #   region = "eu-west-1"
  # }
}

provider "aws" {
  region = var.aws_region
}
