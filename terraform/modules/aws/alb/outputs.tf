output "dns_name" {
  description = "DNS público del ALB"
  value       = aws_lb.this.dns_name
}

output "zone_id" {
  description = "Zone ID del ALB"
  value       = aws_lb.this.zone_id
}

output "arn" {
  description = "ARN del ALB"
  value       = aws_lb.this.arn
}
