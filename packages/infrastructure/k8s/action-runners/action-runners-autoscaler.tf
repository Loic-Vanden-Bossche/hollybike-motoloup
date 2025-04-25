resource "kubernetes_manifest" "runner_autoscaler" {
  manifest = yamldecode(file("${path.module}/values/runner-autoscaler.yaml"))
}