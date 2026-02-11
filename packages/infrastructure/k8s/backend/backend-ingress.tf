resource "kubernetes_ingress_v1" "hollybike_backend_ingress" {
  metadata {
    name      = "hollybike-backend-ingress"
    namespace = var.namespace
    annotations = {
      "cert-manager.io/cluster-issuer"                 = "letsencrypt-production",
      "acme.cert-manager.io/http01-edit-in-place"      = "true",
      "acme.cert-manager.io/http01-ingress-class"      = "nginx",
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true",
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true",
      "nginx.ingress.kubernetes.io/backend-protocol"   = "HTTP",
      "nginx.ingress.kubernetes.io/proxy-body-size"    = "10m",
      "nginx.ingress.kubernetes.io/proxy-read-timeout" = "60",
      "nginx.ingress.kubernetes.io/proxy-send-timeout" = "60"
    }
  }

  spec {
    ingress_class_name = "nginx"

    tls {
      hosts       = [var.domain]
      secret_name = "hollybike-api-cert"
    }

    rule {
      host = var.domain

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.backend.metadata[0].name
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
