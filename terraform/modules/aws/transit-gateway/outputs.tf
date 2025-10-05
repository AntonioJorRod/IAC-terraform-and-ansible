output "tgw_id" {
  value = aws_ec2_transit_gateway.this.id
}

output "attachments" {
  value = { for k, v in aws_ec2_transit_gateway_vpc_attachment.attachments : k => v.id }
}
