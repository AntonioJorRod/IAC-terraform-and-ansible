output "user_role_arns" {
  description = "Map of IAM role ARNs by user"
  value       = {for user_name, role in aws_iam_role.transfer_user_role : user_name => role.arn}
}

output "user_role_names" {
  description = "Map of IAM role names by user"
  value       = {for user_name, role in aws_iam_role.transfer_user_role : user_name => role.name}
}

output "s3_policy_arns" {
  description = "Map of S3 policy ARNs by user"
  value       = {for user_name, policy in aws_iam_role_policy.transfer_s3_policy : user_name => policy.role}
}

output "efs_policy_arns" {
  description = "Map of EFS policy ARNs by user"
  value       = {for user_name, policy in aws_iam_role_policy.transfer_efs_policy : user_name => policy.role}
}

output "logging_policy_arns" {
  description = "Map of logging policy ARNs by user"
  value       = {for user_name, policy in aws_iam_role_policy.transfer_logging_policy : user_name => policy.role}
}

output "custom_policy_arns" {
  description = "Map of custom policy ARNs by user"
  value       = {for user_name, policy in aws_iam_role_policy.transfer_custom_policy : user_name => policy.role}
}
