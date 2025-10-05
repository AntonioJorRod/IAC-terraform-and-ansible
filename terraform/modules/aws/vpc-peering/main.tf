# --- Crea la conexión de peering entre las dos VPC ---
resource "aws_vpc_peering_connection" "this" {
  provider         = aws.requester
  vpc_id           = var.requester_vpc_id
  peer_vpc_id      = var.accepter_vpc_id
  peer_region      = var.accepter_region
  auto_accept      = true
  tags             = merge(var.tags, { Name = var.name })
}

# --- Habilita la resolución DNS desde la VPC solicitante hacia la remota ---
resource "aws_vpc_peering_connection_options" "requester" {
  provider                  = aws.requester
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

# --- Habilita la resolución DNS desde la VPC remota hacia la solicitante ---
resource "aws_vpc_peering_connection_options" "accepter" {
  provider                  = aws.accepter
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}
