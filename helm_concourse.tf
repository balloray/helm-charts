module "concourse_chart" {
  source                  = "github.com/balloray/helm/remote/module"
  chart_name              = "concourse"
  chart_path              = "concourse"
  chart_version           = "17.0.37"
  chart_repo              = "https://concourse-charts.storage.googleapis.com"
  chart_override_values   = <<EOF
concourse:
  web:
    externalUrl: https://concourse.${var.gcp_zone_name}
    auth:
      mainTeam:
        localUser: ${var.concourse["local_admin"]}
    kubernetes:
      teams:
        - my-team

web:
  env:
  - name: CONCOURSE_KUBERNETES_IN_CLUSTER
    value: "true"
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
  replicas: 3

postgresql:
  auth:
    username: ${var.concourse["postgres_user"]}
    password: ${var.concourse["postgres_passwd"]}
    database: ${var.concourse["postgres_db"]}

secrets: 
  localUsers: ${var.concourse["local_admin"]}:${var.concourse["admin_password"]}

rbac:
  create: true
  webServiceAccountName: concourse
  workerServiceAccountName: concourse-worker
EOF

}

resource "kubernetes_cluster_role" "concourse_cluster_role" {
  metadata {
    name = "web-role"
    labels = {
      "app" = "concourse-web"
    }
  }
  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get"]
  }
}
resource "kubernetes_cluster_role_binding" "concourse_cluster_role_binding" {
  metadata {
    name = "web-rolebinding"
    labels = {
      "app" = "concourse-web"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "web-role"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "concourse-web"
  }
}

# # Creating the tls secret for concourse chart
# resource "kubernetes_secret" "concourse_tls_secret" {
#   metadata {
#     name      = "concourse-tls-secret"
#   }
#   data = {
#     "tls.key"            = file(pathexpand("~/helm-charts/sec_concourse_tls.key"))
#     "tls.crt"            = file(pathexpand("~/helm-charts/sec_concourse_tls.crt"))
#   }
#   type = "kubernetes.io/tls"
# }

# ##Creating the secret for concourse
# resource "null_resource" "concourse_secrets" {
#   provisioner "local-exec" {
#     command = <<EOF
#     #!/bin/bash
#     kubectl create secret generic concourse-web --from-literal=local-users=${var.concourse["local_admin"]}:${var.concourse["admin_password"]} --from-file=host-key=sec_host-key.key --from-file=worker-key-pub=sec_worker-key.pub.key --from-file=session-signing-key=sec_session-signing-key.key
#     kubectl create secret generic concourse-worker --from-file=host-key-pub=sec_host-key.pub.key --from-file=worker-key=sec_worker-key.key
# EOF
#   }
# }

# # Creating the secret for tls-cert concourse
# resource "null_resource" "concourse_secrets" {
#   provisioner "local-exec" {
#     command = <<EOF
#     #!/bin/bash
#     kubectl create secret generic concourse-web --from-literal=local-users=${var.concourse["local_admin"]}:${var.concourse["admin_password"]} --from-literal=vault-client-auth-param="${var.concourse["vault_creds"]}" --from-file=host-key=sec_host-key.key --from-file=worker-key-pub=sec_worker-key.pub.key --from-file=session-signing-key=sec_session-signing-key.key
#     kubectl create secret generic concourse-worker --from-file=host-key-pub=sec_host-key.pub.key --from-file=worker-key=sec_worker-key.key
# EOF
#   }
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

      # vault:
      # enabled: true
      # url: https://vault-gke.${var.gcp_zone_name}
      # useAuthParam: true

  # env:
  # - name: CONCOURSE_VAULT_URL
  #   value: "https://vault-gke.${var.gcp_zone_name}"
  # - name: CONCOURSE_VAULT_AUTH_BACKEND
  #   value: approle