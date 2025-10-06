variable "cluster_name" {
  description = "Nombre del cluster EKS donde se desplegará KEDA"
  type        = string
}

variable "namespace" {
  description = "Namespace donde se instalará KEDA"
  type        = string
  default     = "keda"
}

variable "keda_chart_version" {
  description = "Versión del chart de Helm de KEDA"
  type        = string
  default     = "2.14.0"
}

variable "keda_log_level" {
  description = "Nivel de log del operator (info, debug, error)"
  type        = string
  default     = "info"
}

variable "watch_namespace" {
  description = "Namespace que KEDA observará para ScaledObjects (vacío = todos)"
  type        = string
  default     = ""
}
