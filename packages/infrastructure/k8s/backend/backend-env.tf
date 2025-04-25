resource "kubernetes_secret" "backend_env" {
  metadata {
    name      = "backend-env"
    namespace = var.namespace
  }

  data = {
    DB_URL                            = var.database_url
    DB_USERNAME                       = var.database_username
    DB_PASSWORD                       = var.database_password
    MAPBOX_PUBLIC_ACCESS_TOKEN_SECRET = var.mapbox_public_access_token_secret
    SECURITY_AUDIENCE                 = var.security_audience
    SECURITY_DOMAIN                   = "https://${var.domain}"
    SECURITY_REALM                    = var.security_realm
    SECURITY_SECRET                   = var.security_secret
    STORAGE_S3_BUCKET_NAME            = var.storage_s3_bucket_name
    STORAGE_S3_PASSWORD               = var.storage_s3_password
    STORAGE_S3_REGION                 = "us-east-1"
    STORAGE_S3_URL                    = var.storage_s3_url
    STORAGE_S3_USERNAME               = var.storage_s3_username
  }

  type = "Opaque"
}