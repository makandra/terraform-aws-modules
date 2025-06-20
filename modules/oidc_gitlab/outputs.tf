output "gitlab_role_arn" {
  description = "Role that needs to be assumed by GitLab CI."
  value       = aws_iam_role.this.arn
}
