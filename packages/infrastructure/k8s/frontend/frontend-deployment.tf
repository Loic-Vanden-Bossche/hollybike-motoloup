resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "hollybike-frontend"
    namespace = var.namespace
    labels = {
      app = "hollybike-frontend"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "hollybike-frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "hollybike-frontend"
        }
      }

      spec {
        container {
          name  = "frontend"
          image = var.image
          image_pull_policy = "IfNotPresent"

          port {
            container_port = 80
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 5
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }
        }
      }
    }
  }
}