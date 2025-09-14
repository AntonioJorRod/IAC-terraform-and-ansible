resource "aws_iam_openid_connect_provider" "this" {
  url             = var.oidc_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0afd10df6"]
}

output "arn" {
  value = aws_iam_openid_connect_provider.this.arn
}
