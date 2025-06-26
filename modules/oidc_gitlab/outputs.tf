output "gitlab_role_arn" {
  description = "Role that needs to be assumed by GitLab CI."
  value       = aws_iam_role.this.arn
}

output "oidc_connect_provider_config" {
  description = "Configuration of the aws_iam_openid_connect_provider."
  value       = aws_iam_openid_connect_provider.this
}
