module "helm" {
  source                  = "github.com/balloray/helm-chart"
  chart_name              = "concourse"
  chart_path              = "concourse"
  chart_version           = "17.0.37"
  chart_repo             = "https://concourse-charts.storage.googleapis.com"
  chart_override_values   = <<EOF
concourse:
  web:
    externalUrl: https://concourse.${var.google_domain_name}
    auth:
      mainTeam:
        localUser: ${var.concourse["local_user"]}

  ingress:
    enabled: true
    annotations: 
      kubernetes.io/ingress.class: nginx
      cert-manager.io/cluster-issuer: letsencrypt-prod
    hosts: 
      - concourse.${var.google_domain_name}
    tls:
      - secretName: concourse-web-tls
        hosts:
          - concourse.${var.google_domain_name}

worker:
  replicas: 3

postgresql:
  auth:
    username: ${var.concourse["postgres_username"]}
    password: ${var.concourse["postgres_password"]}
    database: ${var.concourse["concourse_postgresql"]}

secrets:
  localUsers: ${var.concourse["local_user"]}:${var.concourse["admin_password"]}
  vaultClientToken: ${var.concourse["vault_token"]}
EOF
}