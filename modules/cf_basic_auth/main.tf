resource "aws_cloudfront_function" "this" {
  name    = var.name
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = templatefile("${path.module}/function.tftpl", { basic_auth = jsonencode(var.basic_auth) })
}
