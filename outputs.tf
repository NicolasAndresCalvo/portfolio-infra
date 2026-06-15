output "bucket" {
  description = "Name of the site bucket (used by scripts/deploy.sh)."
  value       = aws_s3_bucket.site.id
}

output "website_endpoint" {
  description = "Open this in a browser after running scripts/deploy.sh."
  value       = "http://${aws_s3_bucket_website_configuration.site.website_endpoint}"
}
