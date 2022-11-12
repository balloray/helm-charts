module "concourse_chart" {
  source                  = "github.com/balloray/helm-chart/module"
  chart_name              = "concourse"
  chart_path              = "concourse"
  chart_version           = "17.0.37"
  chart_repo              = "https://concourse-charts.storage.googleapis.com"
  chart_override_values   = <<EOF
# image: tanzutap/concourse
# imageTag: 6.7-ubuntu
# # imagePullSecrets: ["regcred"] # Remove if registry is public
concourse:
  web:
    externalUrl: https://concourse.${var.gcp_domain_name}
    kubernetes:
      enabled: false
    vault:
      enabled: true
      url: https://vault.${var.gcp_domain_name}
      useAuthParam: true
    auth:
      mainTeam:
        localUser: ${var.concourse["local_user"]}
web:
  env:
  - name: CONCOURSE_VAULT_URL
    value: "https://vault.${var.gcp_domain_name}"
  - name: CONCOURSE_VAULT_CLIENT_TOKEN
    valueFrom:
      secretKeyRef:
        name: concourse-web
        key: vault-client-token
  ingress:
    enabled: true
    annotations: 
      kubernetes.io/ingress.class: nginx
      cert-manager.io/cluster-issuer: letsencrypt-prod
    hosts: 
    - concourse.${var.gcp_domain_name}
    tls:
    - secretName: concourse-web-tls
      hosts:
      - concourse.${var.gcp_domain_name}

worker:
  replicas: 2

postgresql:
  # image:
  #   registry: docker.io
  #   repository: tanzutap/postgres
  #   tag: latest
  #   ##pullSecrets: ["regcred"] # Remove if registry is public
  auth:
    username: ${var.concourse["postgres_username"]}
    password: ${var.concourse["postgres_password"]}
    database: ${var.concourse["concourse_postgresql"]}

secrets:
  localUsers: ${var.concourse["local_user"]}:${var.concourse["admin_password"]}
  vaultClientToken: ${var.concourse["vault_token"]}
EOF
}