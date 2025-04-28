variable "namespace" {
  description = "The namespace in which to deploy the frontend resources."
  type        = string
}

variable "image" {
  description = "Docker image for the frontend"
  type        = string
}

variable "domain" {
  description = "Domain name for the frontend"
  type        = string
}