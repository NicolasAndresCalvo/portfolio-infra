output "bucket" {
  description = "Name of the site bucket (used by the web deploy pipeline)."
  value       = aws_s3_bucket.site.id
}

output "cloudfront_distribution_id" {
  description = "Set as AWS_S3_BUCKET's companion CLOUDFRONT_DISTRIBUTION_ID in portfolio-web."
  value       = aws_cloudfront_distribution.site.id
}

output "site_url" {
  value = "https://${var.domain_name}"
}
