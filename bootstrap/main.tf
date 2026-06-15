# Remote Terraform state -------------------------------------------------------

resource "aws_s3_bucket" "state" {
  bucket = var.state_bucket
  tags   = var.tags
}

resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket                  = aws_s3_bucket.state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "lock" {
  name         = var.lock_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = var.tags
}

# GitHub OIDC provider ---------------------------------------------------------

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
  tags            = var.tags
}

# Trust policy helper: only this repo (any branch/PR) may assume the role.
data "aws_iam_policy_document" "trust" {
  for_each = {
    infra = "repo:${var.github_owner}/portfolio-infra:*"
    web   = "repo:${var.github_owner}/portfolio-web:*"
  }
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [each.value]
    }
  }
}

# CI role for portfolio-infra: runs Terraform. Broad on a personal account, but
# locked to this repo via OIDC. Tighten later if desired.
resource "aws_iam_role" "infra_ci" {
  name               = "portfolio-infra-ci"
  assume_role_policy = data.aws_iam_policy_document.trust["infra"].json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "infra_ci_admin" {
  role       = aws_iam_role.infra_ci.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Deploy role for portfolio-web: upload to the site bucket + invalidate CloudFront.
resource "aws_iam_role" "web_deploy" {
  name               = "portfolio-web-deploy"
  assume_role_policy = data.aws_iam_policy_document.trust["web"].json
  tags               = var.tags
}

data "aws_iam_policy_document" "web_deploy" {
  statement {
    sid     = "SyncSiteBucket"
    actions = ["s3:ListBucket", "s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = [
      "arn:aws:s3:::${var.site_bucket}",
      "arn:aws:s3:::${var.site_bucket}/*",
    ]
  }
  statement {
    sid       = "InvalidateCDN"
    actions   = ["cloudfront:CreateInvalidation", "cloudfront:GetInvalidation", "cloudfront:ListDistributions"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "web_deploy" {
  name   = "deploy"
  role   = aws_iam_role.web_deploy.id
  policy = data.aws_iam_policy_document.web_deploy.json
}
