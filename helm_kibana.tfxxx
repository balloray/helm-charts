module "kibana_chart" {
  source                  = "github.com/balloray/helm-chart/module"
  chart_name              = "kibana"
  chart_path              = "kibana"
  chart_version           = "7.8.0"
  chart_repo              = "https://helm.elastic.co"
  chart_override_values   = <<EOF
resources:
  requests:
    cpu: "256m"
    memory: "1Gi"
  limits:
    cpu: "512m"
    memory: "1Gi"
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-prod
  path: /
  hosts:
  - "kibana.${var.gcp_domain_name}"
  tls: 
  - secretName: chart-kibana-tls
    hosts:
    - "kibana.${var.gcp_domain_name}"
EOF
}