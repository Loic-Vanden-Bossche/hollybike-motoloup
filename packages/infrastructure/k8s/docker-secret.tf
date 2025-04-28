data "kubernetes_secret" "image_pull" {
  metadata {
    name      = "ghcr-creds"
    namespace = kubernetes_namespace.hollybike.metadata[0].name
  }
}