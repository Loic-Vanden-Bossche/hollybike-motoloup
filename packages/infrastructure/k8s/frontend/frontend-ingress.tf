# resource "kubernetes_ingress_v1" "hollybike_frontend_ingress" {
#   metadata {
#     name      = "hollybike-frontend-ingress"
#     namespace = var.namespace
#
#     annotations = {
#       "cert-manager.io/cluster-issuer"                   = "letsencrypt-production"
#       "nginx.ingress.kubernetes.io/ssl-redirect"         = "true"
#       "nginx.ingress.kubernetes.io/force-ssl-redirect"   = "true"
#       "nginx.ingress.kubernetes.io/backend-protocol"     = "HTTP"
#       "nginx.ingress.kubernetes.io/proxy-read-timeout"   = "60"
#       "nginx.ingress.kubernetes.io/proxy-send-timeout"   = "60"
#       "nginx.ingress.kubernetes.io/proxy-body-size"      = "10m"
#       "nginx.ingress.kubernetes.io/use-regex"            = "true"
#
#       # 👇 Only rewrite app routes; let real assets pass through unchanged
#       "nginx.ingress.kubernetes.io/configuration-snippet" = <<-EOT
#       # Rewrite any path that is NOT a static asset to /index.html
#       # - exclude common asset extensions and well-known files/prefixes
#       rewrite ^/(?!assets/|static/|js/|css/|img/|images/|fonts/|favicon\\.ico$|robots\\.txt$).+ /index.html last;
#     EOT
#     }
#   }
#
#   spec {
#     ingress_class_name = "nginx"
#
#     tls {
#       hosts       = [var.domain]
#       secret_name = "hollybike-cert"
#     }
#
#     rule {
#       host = var.domain
#
#       http {
#         path {
#           path      = "/"
#           path_type = "ImplementationSpecific"
#
#           backend {
#             service {
#               name = kubernetes_service.frontend.metadata[0].name
#               port {
#                 number = 80
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }

//

resource "kubernetes_ingress_v1" "hollybike_frontend_assets" {
  metadata {
    name      = "hollybike-frontend-assets"
    namespace = var.namespace
    annotations = {
      "cert-manager.io/cluster-issuer"                 = "letsencrypt-production"
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "nginx.ingress.kubernetes.io/backend-protocol"   = "HTTP"
      "nginx.ingress.kubernetes.io/use-regex"          = "true"
    }
  }

  spec {
    ingress_class_name = "nginx"

    tls {
      hosts       = [var.domain]
      secret_name = "hollybike-cert"
    }

    rule {
      host = var.domain
      http {
        path {
          # Matches: /assets/**, /static/**, /js/**, /css/**, /img/**, /images/**, /fonts/**
          #          plus single files /favicon.ico and /robots.txt
          path      = "/(?:(?:assets/.*)|.*\\.(png|jpg|jpeg|webp|gif|svg)$|favicon\\.ico$|robots\\.txt$)"
          path_type = "ImplementationSpecific"
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

resource "kubernetes_ingress_v1" "hollybike_frontend_spa" {
  metadata {
    name      = "hollybike-frontend-spa"
    namespace = var.namespace
    annotations = {
      "cert-manager.io/cluster-issuer"                 = "letsencrypt-production"
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "nginx.ingress.kubernetes.io/backend-protocol"   = "HTTP"
      "nginx.ingress.kubernetes.io/use-regex"          = "true"
      "nginx.ingress.kubernetes.io/rewrite-target"     = "/index.html"
    }
  }

  spec {
    ingress_class_name = "nginx"

    tls {
      hosts       = [var.domain]
      secret_name = "hollybike-cert"
    }

    rule {
      host = var.domain
      http {
        path {
          # Absolute path (starts with "/"); exclude static dirs + single files
          path      = "/(?!(assets/|.*\\.(png|jpg|jpeg|webp|gif|svg)$|favicon\\.ico$|robots\\.txt$)).*"
          path_type = "ImplementationSpecific"
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
