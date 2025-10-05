output "peering_connection_id" {
  description = "ID del VPC peering"
  value       = aws_vpc_peering_connection.this.id
}
