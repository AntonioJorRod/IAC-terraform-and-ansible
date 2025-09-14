variable "oidc_provider_arn" {
  type = string
}

variable "oidc_provider_url" {
  type = string
}

variable "namespace" {
  type    = string
  default = "jenkins"
}

variable "serviceaccount" {
  type    = string
  default = "jenkins-sa"
}

variable "policy_arn" {
  type    = string
  default = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
