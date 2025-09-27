variable "domain_name" {
  description = "Dominio raíz"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name del ALB"
  type        = string
}

variable "alb_zone_id" {
  description = "Zone ID del ALB"
  type        = string
}

variable "jenkins_dns_name" {
  description = "DNS name de Jenkins (Ingress en EKS)"
  type        = string
}

variable "tags" {
  description = "Tags comunes"
  type        = map(string)
  default     = {}
}
