resource "kubernetes_namespace_v1" "hollybike" {
  metadata {
    name = "hollybike"
  }
}