resource "kubernetes_stateful_set" "minio" {
  metadata {
    name      = "minio"
    namespace = var.namespace
    labels = {
      app = "minio"
    }
  }

  spec {
    service_name = kubernetes_service.minio.metadata[0].name
    replicas     = 1

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
        security_context {
          run_as_non_root = true
          run_as_user     = 1000
          fs_group        = 1000
        }

        container {
          name  = "minio"
          image = "minio/minio:RELEASE.2025-04-22T22-12-26Z"
          args  = ["server", "/data"]

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

          env {
            name  = "BUCKET_NAME"
            value = var.bucket_name
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

          readiness_probe {
            http_get {
              path = "/minio/health/ready"
              port = 9000
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }

          liveness_probe {
            http_get {
              path = "/minio/health/live"
              port = 9000
            }
            initial_delay_seconds = 10
            period_seconds        = 10
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "minio-data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "20Gi"
          }
        }

        storage_class_name = "longhorn"
      }
    }
  }
}

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