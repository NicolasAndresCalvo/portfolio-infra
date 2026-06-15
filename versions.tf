terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40"
    }
  }

  backend "s3" {
    bucket         = "nicolasandrescalvo-tfstate"
    key            = "portfolio-site/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

# CloudFront requires its ACM certificate in us-east-1, regardless of where the
# bucket lives.
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
