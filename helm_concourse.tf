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
        localUser: ${var.concourse["local_user"]},
        github:
          user: ${var.concourse["users"]}
web:
  env:
  - name: CONCOURSE_VAULT_URL
    value: "https://vault.${var.gcp_domain_name}"
  - name: CONCOURSE_VAULT_CLIENT_TOKEN
    value: ${var.concourse["vault_token"]}
  - name: CONCOURSE_GITHUB_CLIENT_ID
    value: ${var.concourse["github_clien_id"]}
  - name: CONCOURSE_GITHUB_CLIENT_SECRET
    value: ${var.concourse["github_client_secret"]}
  # - name: CONCOURSE_ADD_LOCAL_USER
  #   value: ${var.concourse["local_user"]}:${var.concourse["admin_password"]}
  #   # value:
  #   #   secretKeyRef:
  #   #     name: concourse-web
  #   #     key: local-users

  ingress:
    enabled: true
    annotations: 
      kubernetes.io/ingress.class: nginx
      cert-manager.io/cluster-issuer: letsencrypt-prod
    hosts: 
    - concourse.${var.gcp_domain_name}
    tls:
    - secretName: concourse-tls-secret
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
EOF
}