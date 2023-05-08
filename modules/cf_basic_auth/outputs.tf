output "cf_function_arn" {
  description = "ARN of the created Basic Auth CloudFront Function"
  value       = aws_cloudfront_function.this.arn
}
