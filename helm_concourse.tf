module "concourse_chart" {
  source                  = "github.com/balloray/helm-chart/module"
  chart_name              = "concourse"
  chart_path              = "concourse"
  chart_version           = "17.0.37"
  chart_repo              = "https://concourse-charts.storage.googleapis.com"
  chart_override_values   = <<EOF
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
        localUser: ${var.concourse["local_users"]}
        github:
          user: ${var.concourse["github_users"]}
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

  ingress:
    enabled: true
    annotations: 
      kubernetes.io/ingress.class: nginx
      cert-manager.io/cluster-issuer: letsencrypt-prod
    hosts: 
    - concourse.${var.gcp_domain_name}
    tls:
    - secretName: concourse-tls
      hosts:
      - concourse.${var.gcp_domain_name}

worker:
  replicas: 2

postgresql:
  auth:
    username: ${var.concourse["postgres_username"]}
    password: ${var.concourse["postgres_password"]}
    database: ${var.concourse["concourse_postgresql"]}

secrets:
  localUsers:   ${var.concourse["local_users"]}:${var.concourse["admin_password"]}
  # hostKey: |-
  #   file(pathexpand("~/helm-charts/host-key.key"))
  # hostKeyPub: |-
  #   file(pathexpand("~/helm-charts/host-key.pub.key"))       
  # workerKey: |-
  #   file(pathexpand("~/helm-charts/worker-key.key"))         
  # worker_key_pub: |-
  #   file(pathexpand("~/helm-charts/worker-key'pub.key")) 
  # sessions_signing_key: |-
  #   file(pathexpand("~/helm-charts/session-signing-key.key"))

rbac:
  create: true
  webServiceAccountName: concourse
  workerServiceAccountName: concourse-worker
EOF
}

# resource "kubernetes_secret" "concourse_tls_secret" {
#   metadata {
#     name      = "concourse-tls-secret"
#   }
#   data = {
#     "tls.key"            = file(pathexpand("~/helm-charts/sec_concourse.key"))
#     "tls.crt"            = file(pathexpand("~/helm-charts/sec_concourse.crt"))
#   }
#   type = "kubernetes.io/tls"
# }

# resource "kubernetes_secret" "concourse_host_secret" {
#   metadata {
#     name      = "concourse-web"
#   }
#   data = {
#     # "local-users"         = var.concourse["local_users"]:var.concourse["admin_password"]
#     "host-key"            = file(pathexpand("~/helm-charts/hostkey.key"))
#     "session-signing-key" = file(pathexpand("~/helm-charts/signinkey.key"))
#     "worker-key-pub"      = file(pathexpand("~/helm-charts/workerkey-pub.key"))

#   }
#   type = "Opague"
# }

# resource "kubernetes_secret" "concourse_worker_secret" {
#   metadata {
#     name      = "concourse-worker"
#   }
#   data = {
#     "worker-key"              = file(pathexpand("~/helm-charts/workerkey.key"))
#     "host-key-pub"            = file(pathexpand("~/helm-charts/hostkey-pub.key"))
#   }
#   type = "Opague"
# }

  # hostKey:              ${var.concourse["host_key"]}
  # hostKeyPub:           ${var.concourse["host_key_pub"]}        
  # workerKey:            ${var.concourse["worker_key"]}          
  # worker_key_pub:       ${var.concourse["worker_key_pub"]}  
  # sessions_signing_key: ${var.concourse["sessions_signing_key"]}