resource "aws_iam_role" "jenkins" {
  name = "${var.namespace}-${var.serviceaccount}-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(var.oidc_provider_url, "https://", "")}:sub" = "system:serviceaccount:${var.namespace}:${var.serviceaccount}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_policy" {
  role       = aws_iam_role.jenkins.name
  policy_arn = var.policy_arn
}

output "jenkins_role_arn" {
  value = aws_iam_role.jenkins.arn
}
