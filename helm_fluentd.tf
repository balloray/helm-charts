module "fluentd_chart" {
  source                  = "github.com/balloray/helm-chart/module"
  chart_name              = "fluentd"
  chart_path              = "fluentd"
  chart_version           = "0.2.6"
  chart_repo              = "https://fluent.github.io/helm-charts"
  chart_override_values   = <<EOF
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - name: "fluentd.${var.gcp_domain_name}"
      protocol: TCP
      servicePort: 9880
      path: /
  tls: 
  # Secrets must be manually created in the namespace.
   - secretName: fluent-tls
     hosts:
       - fluentd.${var.gcp_domain_name}
## Additional environment variables to set for fluentd pods
env:
  - name: "FLUENTD_CONF"
    value: "../../etc/fluent/fluent.conf"
  - name: FLUENT_ELASTICSEARCH_HOST
    value: "elasticsearch-master"
  - name: FLUENT_ELASTICSEARCH_PORT
    value: "9200"
fileConfigs:
  03_dispatch.conf: |-
    <label @DISPATCH>
      <filter **>
        @type prometheus
        <metric>
          name fluentd_input_status_num_records_total
          type counter
          desc The total number of incoming records
          <labels>
            
          </labels>
        </metric>
      </filter>
      <match **>
        @type relabel
        @label @OUTPUT
      </match>
    </label>
dashboards:
  enabled: "false"
EOF
}