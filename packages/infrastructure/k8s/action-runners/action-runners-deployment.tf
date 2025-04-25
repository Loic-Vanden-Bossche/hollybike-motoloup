resource "kubernetes_manifest" "runner_deployment" {
  manifest = yamldecode(file("${path.module}/values/runner-deployment.yaml"))
}