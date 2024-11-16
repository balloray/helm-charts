module "concourse_chart" {
  chart_namespace         = "default"
  source                  = "github.com/balloray/helm/local/module"
  chart_name              = "concourse"
  chart_path              = "./charts/concourse-helm/charts"
  # chart_version           = "17.4.0"
  # chart_repo              = "https://concourse-charts.storage.googleapis.com"
  chart_override_values   = <<EOF
image: tanzutap/concourse
imageTag: 7.4-ubuntu
concourse:
  web:
    externalUrl: https://concourse.${var.gcp_zone_name}
    auth:
      mainTeam:
        localUser: ${var.concourse["local_admin"]}
        github:
          user: ${var.concourse["github_users"]}
    kubernetes:
      enabled: false
    vault:
      enabled: true
      url: "https://vault.${var.gcp_zone_name}"
      useAuthParam: true
  worker:
    runtime: containerd

web:
  env:
  - name: CONCOURSE_GITHUB_CLIENT_ID
    value: ${var.concourse["github_client_id"]}
  - name: CONCOURSE_GITHUB_CLIENT_SECRET
    value: ${var.concourse["github_client_secret"]}
  - name: CONCOURSE_VAULT_AUTH_BACKEND
    value: approle

  ingress:
    enabled: true
    annotations: 
      kubernetes.io/ingress.class: nginx
      cert-manager.io/cluster-issuer: letsencrypt-prod
    hosts: 
    - concourse.${var.gcp_zone_name}
    tls:
    - secretName: concourse-tls
      hosts:
      - concourse.${var.gcp_zone_name}

worker:
  replicas: 2

postgresql:
  image:
    registry: docker.io
    repository: tanzutap/postgres
    tag: latest
  volumePermissions:
    enabled: true 
  auth:
    username: ${var.concourse["postgres_user"]}
    password: ${var.concourse["postgres_passwd"]}
    database: ${var.concourse["postgres_db"]}

secrets: 
  localUsers: ${var.concourse["local_admin"]}:${var.concourse["admin_password"]}
  vaultAuthParam: ${var.concourse["vault_creds"]}

rbac:
  create: true
  webServiceAccountName: concourse-web
  workerServiceAccountName: concourse-worker
EOF
}

# data "local_sensitive_file" "host_key" {
#   filename = "${path.module}/sec-host-key.key"
# }

# data "local_sensitive_file" "host_key_pub" {
#   filename = "${path.module}/sec-host-key-pub.key"
# }

# data "local_sensitive_file" "worker_key" {
#   filename = "${path.module}/sec-worker-key.key"
# }

# data "local_sensitive_file" "worker_key_pub" {
#   filename = "${path.module}/sec-worker-key-pub.key"
# }

# data "local_sensitive_file" "session_signing_key" {
#   filename = "${path.module}/sec-session-signing-key.key"
# }

# # Creating the secret for tls
# resource "kubernetes_secret" "concourse_tls_secret" {
#   metadata {
#     name      = "concourse-tls"
#   }
#   data = {
#     "tls.key"            = file(pathexpand("./sec_concourse_tls.key"))
#     "tls.crt"            = file(pathexpand("./sec_concourse_tls.crt"))
#   }
#   type = "kubernetes.io/tls"
# }

    # vault:
    #   enabled: true
    #   url: https://vault-gke.${var.gcp_zone_name}
    #   useAuthParam: true
    # credhub:
    #   enabled: true
    #   url: "https://credhub-gke.${var.gcp_zone_name}"

  # env:
  # - name: CONCOURSE_VAULT_URL
  #   value: "https://vault-gke.${var.gcp_zone_name}"
  # - name: CONCOURSE_VAULT_AUTH_BACKEND
  #   value: approle

  # credhubCaCert:
  # credhubClientid: ${var.concourse["credhub_id"]}
  # credhubClientSecret: ${var.concourse["credhub_secret"]}
  # credhubClientCert:

        # github:
        #   user: ${var.concourse["github_users"]}
  # - name: CONCOURSE_VAULT_CLIENT_TOKEN
  #   value: ${var.concourse["vault_token"]}
  # - name: CONCOURSE_GITHUB_CLIENT_ID
  #   value: ${var.concourse["github_clien_id"]}
  # - name: CONCOURSE_GITHUB_CLIENT_SECRET
  #   value: ${var.concourse["github_client_secret"]}


  # credhubClientId: ${var.concourse["credhub_id"]}
  # credhubClientSecret: ${var.concourse["credhub_secret"]}

  # source                  = "github.com/balloray/helm/remote/module"
  # chart_name              = "concourse"
  # chart_path              = "concourse"
  # chart_version           = "17.0.37"
  # chart_repo              = "https://concourse-charts.storage.googleapis.com"

  # env:
  # - name: CONCOURSE_GITHUB_CLIENT_ID
  #   value: ${var.concourse["github_client_id"]}
  # - name: CONCOURSE_GITHUB_CLIENT_SECRET
  #   value: ${var.concourse["github_client_secret"]}
  # - name: CONCOURSE_VAULT_CLIENT_TOKEN
  #   value: ${var.concourse["vault_creds"]}
  # - name: CONCOURSE_VAULT_AUTH_BACKEND
  #   value: approle

# secrets: 
#   localUsers: ${var.concourse["local_admin"]}:${var.concourse["admin_password"]}
#   vaultAuthParam: ${var.concourse["vault_creds"]}