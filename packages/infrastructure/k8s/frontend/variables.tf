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

variable "docker_secret_name" {
  description = "Name of the Docker secret"
  type        = string
}