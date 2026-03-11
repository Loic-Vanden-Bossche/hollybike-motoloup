data "kubernetes_namespace_v1" "actions_runner_system" {
  metadata {
    name = "actions-runner-system"
  }
}