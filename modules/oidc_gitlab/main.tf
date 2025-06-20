resource "aws_iam_openid_connect_provider" "this" {
  url = var.gitlab_url

  client_id_list = [
    var.gitlab_url,
  ]

  thumbprint_list = var.thumbprint_list
}

resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = var.policies

  role       = aws_iam_role.this.name
  policy_arn = each.value
}
