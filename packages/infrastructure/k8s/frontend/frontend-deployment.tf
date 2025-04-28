resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "hollybike-frontend"
    namespace = var.namespace
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

          port {
            container_port = 80
          }
        }
      }
    }
  }
}