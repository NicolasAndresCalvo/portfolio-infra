terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40"
    }
  }
  # Bootstrap uses LOCAL state on purpose: it creates the very backend + roles the
  # main config and CI rely on, so it cannot itself live in that backend. Run once,
  # locally, with the `min` profile. Everything else goes through the pipeline.
}

provider "aws" {
  region = var.aws_region
}
