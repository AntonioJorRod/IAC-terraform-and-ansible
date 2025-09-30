variable "name_prefix" {
  description = "Prefix for IAM resource names"
  type        = string
}

variable "users" {
  description = "Map of users with their specific configuration"
  type = map(object({
    s3_bucket_access     = bool
    s3_bucket_name       = string
    efs_access           = bool
    efs_file_system_arn  = string
    enable_logging       = bool
    custom_policy        = string
  }))
}

variable "tags" {
  description = "Map of tags for the resources"
  type        = map(string)
  default     = {}
}
