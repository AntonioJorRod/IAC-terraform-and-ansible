# --- Transit Gateway full mesh principal ---
resource "aws_ec2_transit_gateway" "this" {
  description                     = var.description
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  auto_accept_shared_attachments  = "disable"

  tags = merge(var.tags, { Name = var.name })
}

# --- Attach de cada VPC al hub ---
resource "aws_ec2_transit_gateway_vpc_attachment" "attachments" {
  for_each = var.vpc_map

  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = each.value.vpc_id
  subnet_ids         = each.value.private_subnet_ids

  tags = merge(var.tags, { Name = "tgw-attach-${each.key}" })
}
