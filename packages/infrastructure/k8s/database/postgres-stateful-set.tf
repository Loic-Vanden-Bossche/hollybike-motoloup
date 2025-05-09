resource "kubernetes_stateful_set" "postgres" {
  metadata {
    name      = "postgres"
    namespace = var.namespace
    labels = {
      app = "postgres"
    }
  }

  spec {
    service_name = kubernetes_service.postgres.metadata[0].name
    replicas     = 1

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
        security_context {
          run_as_user     = 0
          fs_group        = 999
        }

        container {

          name  = "postgres"
          image = "postgres:17-alpine"
          image_pull_policy = "IfNotPresent"

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

          env {
            name  = "PGDATA"
            value = "/var/lib/postgresql/data/pgdata"
          }

          port {
            container_port = 5432
          }

          volume_mount {
            name       = "postgres-data"
            mount_path = "/var/lib/postgresql/data"
          }

          liveness_probe {
            exec {
              command = ["pg_isready", "-U", var.database_username]
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          readiness_probe {
            exec {
              command = ["pg_isready", "-U", var.database_username]
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "postgres-data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "5Gi"
          }
        }

        storage_class_name = "longhorn"
      }
    }
  }
}