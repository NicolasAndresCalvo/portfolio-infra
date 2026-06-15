variable "aws_region" {
  description = "AWS region for the S3 bucket."
  type        = string
  default     = "eu-west-1"
}

variable "bucket_name" {
  description = "Globally-unique S3 bucket name for the static site."
  type        = string
  default     = "nicolasandrescalvo-portfolio"
}

variable "domain_name" {
  description = "Apex domain. Must already have a public hosted zone in Route53."
  type        = string
  default     = "nicolasandrescalvo.com"
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default = {
    Project   = "portfolio-site"
    ManagedBy = "terraform"
  }
}

locals {
  www_domain = "www.${var.domain_name}"
  aliases    = [var.domain_name, local.www_domain]
}
