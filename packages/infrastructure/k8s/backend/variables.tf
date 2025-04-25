variable "namespace" {
  description = "The namespace in which to deploy the backend resources."
  type        = string
}

variable "image" {
  description = "Docker image for the backend"
  type        = string
}

variable "database_url" {
  description = "Database connection string"
  type        = string
  sensitive   = true
}

variable "database_username" {
  description = "Database username"
  type        = string
  sensitive   = true
}

variable "database_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "mapbox_public_access_token_secret" {
  description = "Mapbox public access token secret"
  type        = string
  sensitive   = true
}

variable "security_audience" {
  description = "Security audience"
  type        = string
  sensitive   = true
}

variable "security_realm" {
  description = "Security realm"
  type        = string
  sensitive   = true
}

variable "security_secret" {
  description = "Security secret"
  type        = string
  sensitive   = true
}

variable "storage_s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
  sensitive   = true
}

variable "storage_s3_password" {
  description = "S3 password"
  type        = string
  sensitive   = true
}

variable "storage_s3_username" {
  description = "S3 username"
  type        = string
  sensitive   = true
}

variable "storage_s3_url" {
  description = "S3 URL"
  type        = string
  sensitive   = true
}

variable "domain" {
  description = "Domain for the backend service"
  type        = string
}