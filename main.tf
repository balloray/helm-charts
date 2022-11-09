## The remote chart deployment 
resource "helm_release" "helm_deployment" {
  name                = var.chart_name
  namespace           = var.deployment_environment
  chart               = var.deployment_path
  timeout             = var.timeout
  recreate_pods       = var.recreate_pods
  version             = var.release_version
  repository          = var.chart_repo

  values = [
    var.chart_override_values
  ]
}