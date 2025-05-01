resource "kubernetes_ingress_v1" "hollybike_frontend_ingress" {
  metadata {
    name      = "hollybike-frontend-ingress"
    namespace = var.namespace

    annotations = {
      "cert-manager.io/cluster-issuer"                 = "letsencrypt-production",
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "nginx.ingress.kubernetes.io/backend-protocol"   = "HTTP"
      "nginx.ingress.kubernetes.io/proxy-read-timeout" = "60"
      "nginx.ingress.kubernetes.io/proxy-send-timeout" = "60"
      "nginx.ingress.kubernetes.io/proxy-body-size"    = "10m",
      "nginx.ingress.kubernetes.io/use-regex"          = "true"
      "nginx.ingress.kubernetes.io/rewrite-target"     = "/index.html"
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
              name = kubernetes_service.frontend.metadata[0].name
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