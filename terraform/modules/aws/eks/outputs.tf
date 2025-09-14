output "cluster_endpoint" {
  description = "Endpoint del EKS"
  value       = aws_eks_cluster.cluster.endpoint
}

output "cluster_certificate_authority" {
  description = "CA del EKS"
  value       = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "node_group_name" {
  description = "Nombre del node group"
  value       = aws_eks_node_group.nodes.id
}

output "cluster_name" {
  description = "Nombre del cluster EKS"
  value       = aws_eks_cluster.cluster.name
}

output "aws_auth_ready" {
  value = null_resource.apply_aws_auth
}

# ebs-csi outputs
output "oidc_provider_url" {
  description = "OIDC issuer URL real del cluster EKS"
  value       = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

output "oidc_provider_arn" {
  description = "ARN del OIDC provider creado en IAM"
  value       = aws_iam_openid_connect_provider.eks.arn
}
