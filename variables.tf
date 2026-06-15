variable "aws_region" {
  description = "AWS region for the S3 bucket."
  type        = string
  default     = "eu-west-1"
}

variable "bucket_name" {
  description = "Globally-unique S3 bucket name for the static site (phase 1, just a test)."
  type        = string
  default     = "nicolasandrescalvo-portfolio"
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default = {
    Project   = "portfolio-site"
    ManagedBy = "terraform"
  }
}
