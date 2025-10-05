# --- EKS ---
output "eks_cluster_endpoint_west" {
  description = "Endpoint del cluster EKS en eu-west-1"
  value       = module.eks_west.cluster_endpoint
}

output "eks_cluster_ca_west" {
  description = "CA del cluster EKS en eu-west-1"
  value       = module.eks_west.cluster_certificate_authority
}

output "cluster_name_west" {
  description = "Nombre del cluster EKS en eu-west-1"
  value       = module.eks_west.cluster_name
}

output "cluster_endpoint_west" {
  description = "Endpoint del cluster EKS en eu-west-1"
  value       = module.eks_west.cluster_endpoint
}

output "cluster_certificate_west" {
  description = "Autoridad de certificados del cluster EKS en eu-west-1"
  value       = module.eks_west.cluster_certificate_authority
}

output "aws_auth_ready_west" {
  description = "Recurso nulo que indica que el aws-auth ConfigMap está aplicado en eu-west-1"
  value       = module.eks_west.aws_auth_ready
}

# --- ALB ---
output "alb_dns_name_west" {
  description = "DNS del Application Load Balancer en eu-west-1"
  value       = module.alb_west.dns_name
}

output "alb_arn_west" {
  description = "ARN del Application Load Balancer en eu-west-1"
  value       = module.alb_west.arn
}

# --- Ansible Core ---
output "ansible_core_id_west" {
  description = "ID de la instancia Ansible Core en eu-west-1"
  value       = module.ec2_ansible_core_west.ansible_core_id
}

output "ansible_core_private_ip_west" {
  description = "IP privada de Ansible Core en eu-west-1"
  value       = module.ec2_ansible_core_west.ansible_core_private_ip
}
