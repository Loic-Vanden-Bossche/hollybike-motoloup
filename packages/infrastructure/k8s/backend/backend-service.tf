resource "kubernetes_service" "backend" {
  metadata {
    name      = "hollybike-backend"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "hollybike-backend"
    }

    port {
      port        = 8080
      target_port = 8080
    }

    type = "ClusterIP"
  }
}