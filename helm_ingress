module "ingress_controller" {
  source                 = "fuchicorp/chart/helm"
  version                = "0.0.12"
  deployment_endpoint    = "ingress.${var.google_domain_name}"
  deployment_name        = "ingress-controller"
  deployment_path        = "ingress-nginx"
  deployment_environment = "sbx"
  enabled                = var.ingress_controller["enabled"]
  remote_chart           = "true"
  ## Making sure the deployment waits for common tools namespace!
  template_custom_vars = {
    namespace_depends_on = kubernetes_namespace.tools.id 
  }
  release_version        = var.ingress_controller["version"]
  chart_repo             = var.ingress_controller["chart_repo_url"]

  ## The Ingress controller values configurations
  remote_override_values = <<EOF
controller:
  config:
    use-forwarded-headers: "true"
    forwarded-for-header: "X-Forwarded-For"

    ## Need for cert managers http challengers
    ## https://github.com/fuchicorp/common_tools/issues/767
    ssl-redirect: "false"
  kind: DaemonSet
  service:
    externalTrafficPolicy: "Local"
    enableHttp: false
EOF
}
