module "vault_chart" {
  source                  = "github.com/balloray/helm-chart/module"
  chart_name              = "vault"
  chart_path              = "vault"
  chart_version           = "0.19.0"
  chart_repo              = "https://helm.releases.hashicorp.com"
  chart_override_values   = <<EOF
injector:
  enabled: false
  # externalVaultAddr: "vault.${var.gcp_domain_name}"
server:
  ingress:
    enabled: true
    labels: {}
    annotations: 
      kubernetes.io/ingress.class: nginx
      cert-manager.io/cluster-issuer: letsencrypt-prod
    hosts:
    - host: "vault.${var.gcp_domain_name}"
      paths:
      - /
    tls:
    - secretName: chart-vault-tls
      hosts:
      - "vault.${var.gcp_domain_name}"
  readinessProbe:
    enabled: false
  dataStorage:
    size: 5Gi
EOF
}

## Creating the vault-init-cm configmap for vault-init-job to unseal the vault server after deployment
resource "kubernetes_config_map" "init_script_config_map" {
  metadata {
    name      = "vault-init-cm"
  }
  data = {
    "init.sh" = file("${path.module}/terraform_templates/vault/init.sh")
  }
  depends_on = [
    module.vault_chart,
  ]
}

## Creating the vault-init-cron-job to unseal the vault server after deployment
resource "kubernetes_cron_job" "vault_init_cron_job" {
  metadata {
    name      = "vault-init-cron-job"
  }

  spec {
    concurrency_policy        = "Replace"
    failed_jobs_history_limit = 1
    schedule                  = "*/3 * * * *"

    job_template {
      metadata {}
      spec {
        backoff_limit              = 2
        ttl_seconds_after_finished = 10
        template {
          metadata {}
          spec {
            automount_service_account_token = "true"
            service_account_name            = kubernetes_service_account.common_service_account.metadata.0.name
            container {
              name    = "vault-init-job"
              image   = "vault:1.4.0"
              command = ["/bin/sh", "-c", "sh /init/init.sh"]
              volume_mount {
                name       = "vault-data"
                mount_path = "/init"
              }
            }
            restart_policy = "OnFailure"
            volume {
              name = "vault-data"
              config_map {
                name = "vault-init-cm"
              }
            }
          }
        }
        #        backoff_limit              = 10
        active_deadline_seconds = 360
        #        ttl_seconds_after_finished = 210
      }
    }
  }
  depends_on = [
    kubernetes_config_map.init_script_config_map,
  ]
}

