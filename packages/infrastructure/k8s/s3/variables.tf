variable "namespace" {
  description = "The namespace in which to deploy the minio resources."
  type        = string
}

variable "username" {
  description = "Username to use for Minio"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "Password to use for Minio"
  type        = string
  sensitive   = true
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}
