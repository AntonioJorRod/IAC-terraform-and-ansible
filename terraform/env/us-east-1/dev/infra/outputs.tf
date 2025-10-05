# --- EKS ---
output "eks_cluster_endpoint" {
  description = "Endpoint del cluster EKS"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_ca" {
  description = "CA del cluster EKS"
  value       = module.eks.cluster_certificate_authority
}

output "cluster_name" {
  description = "Nombre del cluster EKS"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint del cluster EKS"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate" {
  description = "Autoridad de certificados del cluster EKS"
  value       = module.eks.cluster_certificate_authority
}

output "aws_auth_ready" {
  description = "Recurso nulo que indica que el aws-auth ConfigMap está aplicado"
  value       = module.eks.aws_auth_ready
}

# --- ALB ---
output "alb_dns_name" {
  description = "DNS del Application Load Balancer"
  value       = module.alb.dns_name
}

output "alb_arn" {
  description = "ARN del Application Load Balancer"
  value       = module.alb.arn
}

# --- Ansible Core ---
output "ansible_core_id" {
  description = "ID de la instancia Ansible Core"
  value       = module.ec2_ansible_core.ansible_core_id
}

output "ansible_core_private_ip" {
  description = "IP privada de Ansible Core"
  value       = module.ec2_ansible_core.ansible_core_private_ip
}

# --- Para TGW ---
output "vpc_id" {
  description = "ID de la VPC de us-east-1"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Subnets privadas en us-east-1"
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  description = "Subnets públicas en us-east-1"
  value       = module.vpc.public_subnet_ids
}

output "region" {
  description = "Región de la VPC"
  value       = "us-east-1"
}
