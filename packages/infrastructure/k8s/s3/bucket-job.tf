
resource "kubernetes_job" "create_minio_bucket" {
  depends_on = [kubernetes_stateful_set.minio]

  metadata {
    name      = "create-minio-bucket"
    namespace = var.namespace
  }

  spec {
    template {
      metadata {
        name = "create-minio-bucket"
      }

      spec {
        restart_policy = "OnFailure"

        container {
          name  = "mc"
          image = "minio/mc:latest"

          command = ["/bin/sh", "-c"]
          args = [
            "until mc --config-dir /tmp/mc alias set local http://minio:9000 \"$MINIO_ROOT_USER\" \"$MINIO_ROOT_PASSWORD\"; do echo 'Waiting for MinIO...'; sleep 5; done && mc --config-dir /tmp/mc mb -p local/\"$BUCKET_NAME\" || true"
          ]

          env {
            name  = "MINIO_ROOT_USER"
            value = var.username
          }

          env {
            name  = "MINIO_ROOT_PASSWORD"
            value = var.password
          }

          env {
            name  = "BUCKET_NAME"
            value = var.bucket_name
          }
        }
      }
    }
  }
}