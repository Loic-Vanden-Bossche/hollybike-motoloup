resource "kubernetes_service" "frontend" {
  metadata {
    name      = "hollybike-frontend"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = "hollybike-frontend"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}