output "oidc_provider_arn" {
  description = "ARN del OIDC provider creado en IAM"
  value       = aws_iam_openid_connect_provider.this.arn
}

output "oidc_provider_url" {
  description = "OIDC issuer URL real del cluster EKS"
  value       = aws_iam_openid_connect_provider.this.url
}
