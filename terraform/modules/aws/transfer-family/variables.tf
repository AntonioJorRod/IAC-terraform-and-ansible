variable "name" {
  description = "Nombre del servidor Transfer Family"
  type        = string
}

variable "protocols" {
  description = "Lista de protocolos soportados (SFTP, FTP, FTPS)"
  type        = list(string)
  default     = ["SFTP"]
  validation {
    condition = alltrue([
      for protocol in var.protocols : contains(["SFTP", "FTP", "FTPS"], protocol)
    ])
    error_message = "Los protocolos deben ser SFTP, FTP o FTPS."
  }
}

variable "identity_provider_type" {
  description = "Tipo de proveedor de identidad"
  type        = string
  default     = "SERVICE_MANAGED"
  validation {
    condition = contains([
      "SERVICE_MANAGED",
      "API_GATEWAY",
      "AWS_LAMBDA",
      "AWS_DIRECTORY_SERVICE"
    ], var.identity_provider_type)
    error_message = "Tipo de proveedor de identidad no válido."
  }
}

variable "endpoint_type" {
  description = "Tipo de endpoint (PUBLIC, VPC, VPC_ENDPOINT)"
  type        = string
  default     = "PUBLIC"
  validation {
    condition = contains(["PUBLIC", "VPC", "VPC_ENDPOINT"], var.endpoint_type)
    error_message = "Tipo de endpoint no válido."
  }
}

variable "vpc_id" {
  description = "ID de la VPC (requerido si endpoint_type es VPC)"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "Lista de IDs de subnets para el endpoint VPC"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "Lista de IDs de security groups para el endpoint VPC"
  type        = list(string)
  default     = []
}

variable "address_allocation_ids" {
  description = "Lista de allocation IDs de Elastic IPs para VPC endpoint"
  type        = list(string)
  default     = []
}

variable "vpc_endpoint_ids" {
  description = "Lista de IDs de VPC endpoints para VPC_ENDPOINT type"
  type        = list(string)
  default     = []
}

variable "create_security_group" {
  description = "Crear security group por defecto"
  type        = bool
  default     = true
}

variable "allowed_cidr_blocks" {
  description = "Lista de bloques CIDR permitidos para el security group"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "security_policy_name" {
  description = "Nombre de la política de seguridad para SFTP"
  type        = string
  default     = "TransferSecurityPolicy-2020-06"
}

variable "logging_role_arn" {
  description = "ARN del rol IAM para logging (opcional)"
  type        = string
  default     = ""
}

variable "create_log_group" {
  description = "Crear CloudWatch log group"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Días de retención para los logs"
  type        = number
  default     = 30
}

variable "users" {
  description = "Mapa de usuarios con su configuración"
  type = map(object({
    role_arn       = optional(string, "")
    home_directory = string
    policy         = optional(string, "")
    ssh_keys       = optional(map(string), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.users : v.home_directory != ""
    ])
    error_message = "El home_directory es requerido para todos los usuarios."
  }
}

variable "tags" {
  description = "Mapa de tags para los recursos"
  type        = map(string)
  default     = {}
}
