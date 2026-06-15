# Phase 1: the simplest thing that serves the site.
# A single S3 bucket with static website hosting (HTTP, no custom domain).
# Website hosting resolves index.html inside subfolders automatically, which is
# exactly what Astro's directory-style output (/cases/<slug>/index.html) needs.
#
# Phase 2 (next): put CloudFront + ACM (us-east-1) + Route53 in front for HTTPS
# and the nicolasandrescalvo.com domain, and lock the bucket down behind an OAC.

resource "aws_s3_bucket" "site" {
  bucket = var.bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

# Static website hosting requires the objects to be publicly readable.
resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "public_read" {
  statement {
    sid       = "PublicReadGetObject"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.site.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "site" {
  bucket     = aws_s3_bucket.site.id
  policy     = data.aws_iam_policy_document.public_read.json
  depends_on = [aws_s3_bucket_public_access_block.site]
}
