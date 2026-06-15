# AGENTS.md — portfolio-infra

AWS infrastructure for the portfolio site. Terraform. Public repo.

## Phases

- **Phase 1 (current):** a single S3 bucket with static website hosting. HTTP, no custom
  domain. Just enough to get the site live. See `main.tf`.
- **Phase 2:** CloudFront + ACM (cert in `us-east-1`) + Route53 for HTTPS and
  `nicolasandrescalvo.com`, S3 locked behind an Origin Access Control, a CloudFront
  Function to rewrite directory paths to `index.html`, remote S3 state backend, and an
  OIDC role for CI to assume.

## Commands

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan
terraform apply      # phase 1: run locally until the remote backend is enabled
```

## Conventions

- Everything is variables/outputs: no hardcoded account ids, bucket names or ARNs in code.
- State and tfvars are gitignored. This repo is PUBLIC: never commit `*.tfstate`,
  `*.tfvars`, credentials or account ids.
- CloudFront's ACM certificate MUST live in `us-east-1` (a provider alias), regardless of
  the site's region.
- CI (`.github/workflows/terraform.yml`) runs fmt/validate/plan on PRs and apply on `main`
  via AWS OIDC (`AWS_TERRAFORM_ROLE_ARN`). CI apply needs the remote backend enabled.

## Outputs consumed by portfolio-web

`bucket` (and in phase 2 the CloudFront distribution id) feed `portfolio-web`'s deploy
pipeline as GitHub repo variables. The two repos do not read each other's files.
