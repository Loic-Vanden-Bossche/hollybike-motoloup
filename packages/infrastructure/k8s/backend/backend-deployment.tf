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
          name  = "backend"
          image = var.image

          env_from {
            secret_ref {
              name = kubernetes_secret.backend_env.metadata[0].name
            }
          }

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}