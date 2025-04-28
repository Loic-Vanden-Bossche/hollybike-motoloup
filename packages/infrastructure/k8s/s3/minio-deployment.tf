resource "kubernetes_deployment" "minio" {
  metadata {
    name      = "minio"
    namespace = var.namespace
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "minio"
      }
    }

    template {
      metadata {
        labels = {
          app = "minio"
        }
      }

      spec {
        container {
          name  = "minio"
          image = "minio/minio:latest"
          args = ["server", "/data"]

          env {
            name  = "MINIO_ROOT_USER"
            value = var.username
          }

          env {
            name  = "MINIO_ROOT_PASSWORD"
            value = var.password
          }

          env {
            name  = "MINIO_CONSOLE_ADDRESS"
            value = ":9001"
          }

          port {
            container_port = 9000
          }

          port {
            container_port = 9001
          }

          volume_mount {
            name       = "minio-data"
            mount_path = "/data"
          }

          lifecycle {
            post_start {
              exec {
                command = [
                  "/bin/sh",
                  "-c",
                  "(sleep 10 && mc alias set local http://localhost:9000 \"$MINIO_ROOT_USER\" \"$MINIO_ROOT_PASSWORD\" && mc mb -p local/\"$BUCKET_NAME\" || true) &"
                ]
              }
            }
          }

          env {
            name  = "BUCKET_NAME"
            value = var.bucket_name
          }
        }

        volume {
          name = "minio-data"
          empty_dir {}
        }
      }
    }
  }
}