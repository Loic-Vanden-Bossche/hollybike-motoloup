variable "frontend_image" {
  description = "Docker image for the frontend"
  type        = string
}

variable "backend_image" {
  description = "Docker image for the backend"
  type        = string
}
variable "database_name" {
  description = "Database name"
  type        = string
  default     = "hollybike"
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

variable "security_realm" {
  description = "Security realm"
  type        = string
  default     = "hollybike-auth"
}

variable "security_secret" {
  description = "Security secret"
  type        = string
  sensitive   = true
}

variable "storage_s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = "hollybike"
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

variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "base_domain" {
  description = "Base domain for the application"
  type        = string
  default     = "chbrx.com"
}

variable "backend_subdomain" {
  description = "Backend subdomain"
  type        = string
  default     = "api.hollybike"
}

variable "frontend_subdomain" {
  description = "Frontend subdomain"
  type        = string
  default     = "hollybike"
}

variable "repository_name" {
  description = "GitHub repository name"
  type        = string
}