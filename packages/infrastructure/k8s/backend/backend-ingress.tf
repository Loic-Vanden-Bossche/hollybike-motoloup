resource "kubernetes_ingress_v1" "hollybike_backend_ingress" {
  metadata {
    name      = "hollybike-backend-ingress"
    namespace = var.namespace
    annotations = {
      "cert-manager.io/cluster-issuer" = "letsencrypt-production",
    }
  }

  spec {
    ingress_class_name = "nginx"

    tls {
      hosts = [var.domain]
      secret_name = "hollybike-api-cert"
    }

    rule {
      host = var.domain

      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "hollybike-backend"
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}