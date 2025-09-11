variable "namespace" {
  type = string
}

variable "release_name" {
  type = string
}

variable "chart_version" {
  type = string
}

variable "cluster_endpoint" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "aws_auth_ready" {
  type = any
}
