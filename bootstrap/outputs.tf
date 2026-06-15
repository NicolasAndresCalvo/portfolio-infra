output "state_bucket" {
  value = aws_s3_bucket.state.id
}

output "lock_table" {
  value = aws_dynamodb_table.lock.id
}

output "infra_ci_role_arn" {
  description = "Set as secret AWS_TERRAFORM_ROLE_ARN in portfolio-infra."
  value       = aws_iam_role.infra_ci.arn
}

output "web_deploy_role_arn" {
  description = "Set as secret AWS_DEPLOY_ROLE_ARN in portfolio-web."
  value       = aws_iam_role.web_deploy.arn
}
