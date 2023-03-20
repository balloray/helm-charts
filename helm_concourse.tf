module "concourse_chart" {
  source                  = "github.com/balloray/helm/local/module"
  chart_name              = "concourse"
  chart_path              = "./charts/concourse-helm/charts"
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
      teams:
        - my-team

web:
  env:
  - name: CONCOURSE_KUBERNETES_IN_CLUSTER
    value: "true"
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
    - concourse.${var.gcp_zone_name}
    tls:
    - secretName: concourse-tls
      hosts:
      - concourse.${var.gcp_zone_name}

worker:
  replicas: 3

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
  hostKey: |-
    ${indent(4, data.template_file.host_key.rendered)}
  hostKeyPub: |-
    ${indent(4, data.template_file.host_key_pub.rendered)}
  workerKey: |-
    ${indent(4, data.template_file.worker_key.rendered)}
  workerKeyPub: |-
    ${indent(4, data.template_file.worker_key_pub.rendered)}
  sessionSigningKey: |-
    ${indent(4, data.template_file.session_signing_key.rendered)}

rbac:
  create: true
  webServiceAccountName: concourse
  workerServiceAccountName: concourse-worker
EOF

}

data "template_file" "host_key" {
  template = file("sec-host-key.key")
  vars     = {}
}

data "template_file" "host_key_pub" {
  template = file("sec-host-key-pub.key")
  vars     = {}
}

data "template_file" "worker_key" {
  template = file("sec-worker-key.key")
  vars     = {}
}

data "template_file" "worker_key_pub" {
  template = file("sec-worker-key-pub.key")
  vars     = {}
}

data "template_file" "session_signing_key" {
  template = file("sec-session-signing-key.key")
  vars     = {}
}

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