module "nginx_chart" {
  source                  = "github.com/balloray/helm-chart/module"
  chart_name              = "ingress-controller"
  chart_path              = "ingress-nginx"
  chart_version           = "4.0.19"
  chart_repo             = "https://kubernetes.github.io/ingress-nginx"
  chart_override_values   = <<EOF
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
    # loadBalancerIP: "34.69.143.228"
    # annotations:
    #   cloud.google.com/load-balancer-type: "internal"

# resource "kubernetes_service_account" "common_service_account" {
#   metadata {
#     name      = "common-service-account"
#   }
#   secret {
#     name = kubernetes_secret.common_service_account_secret.metadata.0.name
#   }
#   automount_service_account_token = true
# }

# resource "kubernetes_secret" "common_service_account_secret" {
#   metadata {
#     name      = "common-service-account-secret"
#   }
# }