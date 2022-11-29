module "concourse_chart" {
  source                  = "github.com/balloray/helm-chart/module"
  chart_name              = "concourse"
  chart_path              = "concourse"
  chart_version           = "17.0.37"
  chart_repo              = "https://concourse-charts.storage.googleapis.com"
  chart_override_values   = <<EOF
concourse:
  web:
    externalUrl: https://concourse-gke.${var.gcp_zone_name}
    kubernetes:
      enabled: false
    auth:
      mainTeam:
        localUser: ${var.concourse["local_admin"]}
    vault:
      enabled: true
      url: https://vault-gke.${var.gcp_zone_name}
      useAuthParam: true

web:
  env:
  - name: CONCOURSE_VAULT_URL
    value: "https://vault-gke.${var.gcp_zone_name}"
  - name: CONCOURSE_VAULT_AUTH_BACKEND
    value: approle
  ingress:
    enabled: true
    annotations: 
      kubernetes.io/ingress.class: nginx
    hosts: 
    - concourse-gke.${var.gcp_zone_name}
    tls:
    - secretName: concourse-tls-secret
      hosts:
      - concourse-gke.${var.gcp_zone_name}

worker:
  replicas: 2

postgresql:
  auth:
    username: ${var.concourse["postgres_username"]}
    password: ${var.concourse["postgres_password"]}
    database: ${var.concourse["concourse_postgresql"]}

secrets: 
  create: false

rbac:
  create: true
  webServiceAccountName: concourse
  workerServiceAccountName: concourse-worker
EOF

}

resource "kubernetes_secret" "concourse_tls_secret" {
  metadata {
    name      = "concourse-tls-secret"
  }
  data = {
    "tls.key"            = file(pathexpand("~/helm-charts/sec_concourse_tls.key"))
    "tls.crt"            = file(pathexpand("~/helm-charts/sec_concourse_tls.crt"))
  }
  type = "kubernetes.io/tls"
}

# Creating the secret for cert concourse
resource "null_resource" "concourse_secret" {
  provisioner "local-exec" {
    command = <<EOF
    #!/bin/bash
    kubectl create secret generic concourse-web --from-literal=local-users=${var.concourse["local_admin"]}:${var.concourse["admin_password"]} --from-literal=vault-client-auth-param="${var.concourse["vault_creds"]}" --from-file=host-key=sec_host-key.key --from-file=worker-key-pub=sec_worker-key.pub.key --from-file=session-signing-key=sec_session-signing-key.key
    kubectl create secret generic concourse-worker --from-file=host-key-pub=sec_host-key.pub.key --from-file=worker-key=sec_worker-key.key
EOF
  }
}

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

  # create: false
  # localUsers: ${var.concourse["local_admin"]}:${var.concourse["admin_password"]}
  # credhubClientId: ${var.concourse["credhub_id"]}
  # credhubClientSecret: ${var.concourse["credhub_secret"]}


# resource "kubernetes_secret" "concourse_host_secret" {
#   metadata {
#     name      = "concourse-web"
#   }
#   data = {
#     "local-users"         = var.concourse["local_users"]:var.concourse["admin_password"]
#     "host-key"            = file(pathexpand("~/helm-charts/host-key.key"))
#     "session-signing-key" = file(pathexpand("~/helm-charts/session-signing-key.key"))
#     "worker-key-pub"      = file(pathexpand("~/helm-charts/worker-key-pub.key"))

#   }
#   type = "Opague"
# }

# resource "kubernetes_secret" "concourse_worker_secret" {
#   metadata {
#     name      = "concourse-worker"
#   }
#   data = {
#     "worker-key"              = file(pathexpand("~/helm-charts/worker-key.key"))
#     "host-key-pub"            = file(pathexpand("~/helm-charts/host-key-pub.key"))
#   }
#   type = "Opague"
# }

  # depends_on = [
  #   module.vault_chart,
  # ]