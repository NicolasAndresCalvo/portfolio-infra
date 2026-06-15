# Roadmap

## Phase 1 — basic test (current)

- [x] S3 bucket with static website hosting (HTTP, no domain).
- [ ] `terraform apply` against the personal AWS account.
- [ ] `portfolio-web` deployed and reachable on the S3 website endpoint.

## Phase 2 — production

- [ ] ACM certificate for `nicolasandrescalvo.com` (+ `www`) in `us-east-1`.
- [ ] CloudFront distribution, S3 locked behind an Origin Access Control (no longer public).
- [ ] CloudFront Function to rewrite directory paths to `index.html`.
- [ ] Route53 ALIAS records (apex + www) to CloudFront.
- [ ] Remote S3 state backend (so CI can apply).
- [ ] OIDC role for GitHub Actions (`portfolio-infra-ci`) and a deploy role for
      `portfolio-web` (`portfolio-web-deploy`).

## Notes

- CloudFront's certificate must be in `us-east-1` regardless of the bucket region.
- The S3 website endpoint resolves `index.html` in subfolders on its own; behind
  CloudFront with an OAC that behaviour is lost, hence the rewrite Function in phase 2.
