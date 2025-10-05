resource "aws_iam_policy" "jenkins_extended" {
  name        = "jenkins-extended-policy"
  description = "Permite a Jenkins operar en múltiples VPC y servicios AWS"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "ec2:CreateTags",
          "eks:Describe*",
          "eks:List*",
          "s3:GetObject",
          "s3:PutObject",
          "iam:PassRole"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_policy" {
  role       = aws_iam_role.jenkins.name
  policy_arn = aws_iam_policy.jenkins_extended.arn
}
