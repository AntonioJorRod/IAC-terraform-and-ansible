# IAM Module for AWS Transfer Family
# Provides roles and policies for SFTP users

# IAM Role for Transfer Family Users
resource "aws_iam_role" "transfer_user_role" {
  for_each = var.users

  name = "${var.name_prefix}-${each.key}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "transfer.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${each.key}"
  })
}

# IAM Policy for S3 Access
resource "aws_iam_role_policy" "transfer_s3_policy" {
  for_each = { for k, v in var.users : k => v if v.s3_bucket_access }

  name = "${var.name_prefix}-${each.key}-s3-policy"
  role = aws_iam_role.transfer_user_role[each.key].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:GetObjectVersion",
          "s3:PutObjectAcl",
          "s3:GetObjectAcl"
        ]
        Resource = [
          "arn:aws:s3:::${each.value.s3_bucket_name}",
          "arn:aws:s3:::${each.value.s3_bucket_name}/*"
        ]
      }
    ]
  })
}

# IAM Policy for EFS Access (opcional)
resource "aws_iam_role_policy" "transfer_efs_policy" {
  for_each = { for k, v in var.users : k => v if v.efs_access }

  name = "${var.name_prefix}-${each.key}-efs-policy"
  role = aws_iam_role.transfer_user_role[each.key].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "elasticfilesystem:ClientMount",
          "elasticfilesystem:ClientWrite",
          "elasticfilesystem:ClientRead"
        ]
        Resource = each.value.efs_file_system_arn
      }
    ]
  })
}

# IAM Policy for CloudWatch Logging
resource "aws_iam_role_policy" "transfer_logging_policy" {
  for_each = { for k, v in var.users : k => v if v.enable_logging }

  name = "${var.name_prefix}-${each.key}-logging-policy"
  role = aws_iam_role.transfer_user_role[each.key].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}

# Custom Policy for specific user requirements
resource "aws_iam_role_policy" "transfer_custom_policy" {
  for_each = { for k, v in var.users : k => v if v.custom_policy != "" }

  name = "${var.name_prefix}-${each.key}-custom-policy"
  role = aws_iam_role.transfer_user_role[each.key].id

  policy = each.value.custom_policy
}
