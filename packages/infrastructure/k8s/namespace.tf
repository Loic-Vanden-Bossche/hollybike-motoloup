resource "kubernetes_namespace" "hollybike" {
  metadata {
    name = "hollybike"
  }
}