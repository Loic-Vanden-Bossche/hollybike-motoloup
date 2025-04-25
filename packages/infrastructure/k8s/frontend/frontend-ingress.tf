resource "kubernetes_ingress_v1" "hollybike_frontend_ingress" {
  metadata {
    name      = "hollybike-frontend-ingress"
    namespace = var.namespace
    annotations = {
      "cert-manager.io/cluster-issuer"             = "letsencrypt-production",
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    ingress_class_name = "nginx"

    tls {
      hosts = [var.domain]
      secret_name = "hollybike-cert"
    }

    rule {
      host = var.domain

      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "hollybike-frontend"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}