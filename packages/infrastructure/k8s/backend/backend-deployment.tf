resource "kubernetes_deployment" "backend" {
  metadata {
    name      = "hollybike-backend"
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "hollybike-backend"
      }
    }
    template {
      metadata {
        labels = {
          app = "hollybike-backend"
        }
      }
      spec {
        container {
          security_context {
            run_as_non_root = true
            run_as_user     = 1000
          }

          name  = "backend"
          image = var.image

          env_from {
            secret_ref {
              name = kubernetes_secret.backend_env.metadata[0].name
            }
          }

          liveness_probe {
            http_get {
              path = "/api"
              port = 8080
            }
            initial_delay_seconds = 5
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/api"
              port = 8080
            }
            initial_delay_seconds = 5
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}