# portfolio-infra

Terraform for the AWS hosting of [`portfolio-web`](../portfolio-web).

## Phase 1 (current) — basic test

A single S3 bucket with static website hosting. HTTP only, no custom domain. The goal is
to get the site live and confirm the pipeline end to end.

### Prerequisites

- AWS credentials configured (`aws sts get-caller-identity` must work).
- `bucket_name` must be globally unique. Override it if the default is taken: create
  `terraform.tfvars` with `bucket_name = "something-unique"`.

### Deploy

```bash
terraform init
terraform apply          # creates the bucket, prints the website_endpoint

# then, from the portfolio-web repo:
AWS_S3_BUCKET=$(terraform output -raw bucket) ../portfolio-web/scripts/deploy.sh
```

Open the printed `website_endpoint`. To tear everything down: `terraform destroy`.

## Phase 2 (next) — production

CloudFront + ACM (certificate in `us-east-1`) + Route53 for HTTPS and the
`nicolasandrescalvo.com` domain, S3 locked behind an Origin Access Control (no longer
public), a CloudFront Function to rewrite directory paths to `index.html`, a remote S3
state backend, and OIDC roles so CI can apply. See [`docs/roadmap.md`](./docs/roadmap.md).

## CI

`.github/workflows/terraform.yml` runs fmt/validate/plan on PRs and apply on `main` via
AWS OIDC. CI apply requires the remote backend (phase 2); until then, apply locally.

> This repo is **public**: never commit `*.tfstate`, `*.tfvars`, credentials or account ids.
