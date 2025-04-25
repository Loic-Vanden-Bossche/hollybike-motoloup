output "url" {
  value = "http://${kubernetes_service.minio.metadata[0].name}.${var.namespace}.svc.cluster.local:9000"
  description = "Local url to access the S3 service"
}