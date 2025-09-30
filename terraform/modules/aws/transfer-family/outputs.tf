output "transfer_server_id" {
  description = "ID of the Transfer Family server"
  value       = aws_transfer_server.main.id
}

output "transfer_server_arn" {
  description = "ARN of the Transfer Family server"
  value       = aws_transfer_server.main.arn
}

output "transfer_server_endpoint" {
  description = "Endpoint of the Transfer Family server"
  value       = aws_transfer_server.main.endpoint
}

output "transfer_server_host_key_fingerprint" {
  description = "Host key fingerprint of the SFTP server"
  value       = try(aws_transfer_server.main.host_key_fingerprint, null)
}

output "security_group_id" {
  description = "ID of the created security group"
  value       = var.create_security_group ? aws_security_group.transfer_sg[0].id : null
}

output "security_group_arn" {
  description = "ARN of the created security group"
  value       = var.create_security_group ? aws_security_group.transfer_sg[0].arn : null
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = var.create_log_group ? aws_cloudwatch_log_group.transfer_logs[0].name : null
}

output "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = var.create_log_group ? aws_cloudwatch_log_group.transfer_logs[0].arn : null
}

output "user_names" {
  description = "List of created user names"
  value       = [for user in aws_transfer_user.users : user.user_name]
}

output "user_arns" {
  description = "Map of user ARNs by user name"
  value       = {for user_name, user in aws_transfer_user.users : user_name => user.arn}
}

output "iam_role_arns" {
  description = "Map of IAM role ARNs created by user name"
  value       = {for user_name, role in aws_iam_role.user_role : user_name => role.arn}
}

output "ssh_key_ids" {
  description = "Map of SSH key IDs by user and key name"
  value       = {for key_id, key in aws_transfer_ssh_key.user_ssh_keys : key_id => key.id}
}

output "logging_role_arn" {
  description = "ARN of the created IAM logging role"
  value       = var.logging_role_arn == "" ? (length(aws_iam_role.transfer_logging) > 0 ? aws_iam_role.transfer_logging[0].arn : null) : var.logging_role_arn
}
