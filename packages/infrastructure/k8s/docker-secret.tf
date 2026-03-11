data "kubernetes_namespace_v1" "chbrx" {
  metadata {
    name = "chbrx"
  }
}

data "kubernetes_secret_v1" "image_pull" {
  metadata {
    name      = "ghcr-creds"
    namespace = data.kubernetes_namespace_v1.chbrx.metadata[0].name
  }
}