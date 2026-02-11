output "url" {
  value       = "jdbc:postgresql://${kubernetes_service.postgres.metadata[0].name}.${var.namespace}.svc.cluster.local:5432/${var.database_name}"
  description = "Database connection string"
}