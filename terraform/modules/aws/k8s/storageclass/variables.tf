variable "name" {
  description = "Nombre del StorageClass"
  type        = string
}

variable "volume_type" {
  description = "Tipo de volumen EBS (gp2, gp3, io1, etc.)"
  type        = string
  default     = "gp3"
}
