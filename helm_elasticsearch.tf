module "elasticsearch_chart" {
  source                  = "github.com/balloray/helm-chart/module"
  chart_name              = "elastic-search"
  chart_path              = "elastic-search"
  chart_version           = "7.8.0"
  chart_repo              = "https://helm.elastic.co"
  chart_override_values   = <<EOF
  remote_override_values = <<EOF
replicas: 1
minimumMasterNodes: 1
clusterHealthCheckParams: 'wait_for_status=yellow&timeout=1s'
esJavaOpts: "-Xmx512m -Xms512m"
resources:
  requests:
    cpu: "1000m"
    memory: "1Gi"
  limits:
    cpu: "1000m"
    memory: "1Gi"
volumeClaimTemplate:
  accessModes: [ "ReadWriteOnce" ]
  resources:
    requests:
      storage: 10Gi
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-prod
  path: /
  hosts:
  - "elasticsearch.${var.gcp_domain_name}"
  tls:
  - secretName: chart-elasticsearch-tls
    hosts:
    - "elasticsearch.${var.gcp_domain_name}"
EOF
}