resource "kubernetes_deployment" "postgres" {
  metadata {
    name      = "postgres"
    namespace = var.namespace
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = "postgres:15"

          env {
            name  = "POSTGRES_USER"
            value = var.database_username
          }

          env {
            name  = "POSTGRES_PASSWORD"
            value = var.database_password
          }

          env {
            name  = "POSTGRES_DB"
            value = var.database_name
          }

          port {
            container_port = 5432
          }

          volume_mount {
            name       = "postgres-storage"
            mount_path = "/var/lib/postgresql/data"
          }
        }

        volume {
          name = "postgres-storage"

          empty_dir {}
          # Replace with persistentVolumeClaim if you want persistence
        }
      }
    }
  }
}