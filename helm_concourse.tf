module "concourse_deploy" {
  source                 = "fuchicorp/chart/helm"
  deployment_name        = "concourse"
  deployment_environment = var.deployment_environment
  deployment_path        = "concourse"
  chart_repo             = var.concourse["chart_repo_url"]
  enabled                = true
  remote_chart           = true
  release_version        = var.concourse["version"]
  remote_override_values = <<EOF
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