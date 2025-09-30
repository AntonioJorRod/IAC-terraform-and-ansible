# AWS Transfer Family Module
# Supports SFTP, FTP, and FTPS protocols

resource "aws_transfer_server" "main" {
  identity_provider_type = var.identity_provider_type
  logging_role          = var.logging_role_arn != "" && var.logging_role_arn != null ? var.logging_role_arn : aws_iam_role.transfer_logging[0].arn
  protocols             = var.protocols
  security_policy_name  = var.security_policy_name

  endpoint_details {
    address_allocation_ids = var.address_allocation_ids
    subnet_ids            = var.subnet_ids
    security_group_ids    = var.security_group_ids
  }

  endpoint_type = var.endpoint_type

  tags = merge(var.tags, {
    Name = "${var.name}-transfer-server"
  })
}

# IAM Role for Transfer Family Logging
resource "aws_iam_role" "transfer_logging" {
  count = var.logging_role_arn == "" ? 1 : 0

  name = "${var.name}-transfer-logging-role"

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
    Name = "${var.name}-transfer-logging"
  })
}

resource "aws_iam_role_policy" "transfer_logging" {
  count = var.logging_role_arn == "" ? 1 : 0

  name = "${var.name}-transfer-logging-policy"
  role = aws_iam_role.transfer_logging[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# CloudWatch Log Group for Transfer Family
resource "aws_cloudwatch_log_group" "transfer_logs" {
  count = var.create_log_group ? 1 : 0

  name              = "/aws/transfer/${var.name}"
  retention_in_days = var.log_retention_days

  tags = merge(var.tags, {
    Name = "${var.name}-transfer-logs"
  })
}

# Transfer Users
resource "aws_transfer_user" "users" {
  for_each = var.users

  server_id      = aws_transfer_server.main.id
  user_name      = each.key
  role          = each.value.role_arn != "" && each.value.role_arn != null ? each.value.role_arn : aws_iam_role.user_role[each.key].arn
  home_directory = each.value.home_directory
  policy        = each.value.policy

  tags = merge(var.tags, {
    Name = "${var.name}-user-${each.key}"
  })
}

# IAM Roles for Users
resource "aws_iam_role" "user_role" {
  for_each = { for k, v in var.users : k => v if v.role_arn == "" || v.role_arn == null }

  name = "${var.name}-transfer-user-${each.key}"

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
    Name = "${var.name}-user-role-${each.key}"
  })
}

resource "aws_iam_role_policy" "user_policy" {
  for_each = { for k, v in var.users : k => v if v.role_arn == "" || v.role_arn == null }

  name = "${var.name}-transfer-user-${each.key}-policy"
  role = aws_iam_role.user_role[each.key].id

  policy = each.value.policy != "" ? each.value.policy : jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "*"
      }
    ]
  })
}

# SSH Keys for Users
resource "aws_transfer_ssh_key" "user_ssh_keys" {
  for_each = { for pair in flatten([
    for user_name, user_config in var.users : [
      for key_name, key_body in user_config.ssh_keys : {
        user_key = "${user_name}_${key_name}"
        user_name = user_name
        key_name  = key_name
        key_body  = key_body
      }
    ]
  ]) : pair.user_key => pair }

  server_id   = aws_transfer_server.main.id
  user_name   = each.value.user_name
  body        = each.value.key_body
}

# Security Group for Transfer Family
resource "aws_security_group" "transfer_sg" {
  count = var.create_security_group ? 1 : 0

  name        = "${var.name}-transfer-sg"
  description = "Security group for AWS Transfer Family"
  vpc_id      = var.vpc_id

  ingress {
    description = "SFTP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    description = "FTP"
    from_port   = 21
    to_port     = 21
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    description = "FTPS"
    from_port   = 990
    to_port     = 990
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    description = "FTP Data"
    from_port   = 2000
    to_port     = 2001
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-transfer-sg"
  })
}
