module "cert_manager_chart" {
  chart_namespace         = "default"
  source                  = "github.com/balloray/helm/remote/module"
  chart_name              = "cert-manager"
  chart_path              = "cert-manager"
  chart_version           = "1.7.2"
  chart_repo              = "https://charts.jetstack.io"
  chart_override_values   = <<EOF
installCRDs: true

EOF
}

## Creating the cluster issuer for cert manager
resource "null_resource" "cert_manager_cluster_issuer" {
  depends_on = [module.cert_manager_chart]
  provisioner "local-exec" {
    command = <<EOF
    #!/bin/bash
    ## Creating the cluster issuer
    kubectl apply --validate=false  -f  terraform_templates/cert-manager/issuer.yaml
EOF
  }
}

# extraArgs:
#   - --dns01-recursive-nameservers-only
#   - --dns01-recursive-nameservers=8.8.8.8:53,1.1.1.1:53

# Creating the secret to access GCP 
resource "kubernetes_secret" "gcp_service_account" {
  metadata {
    name      = "google-service-account"
  }
  data = {
    "credentials.json" = file(pathexpand("~/google.json"))
  }
  type = "generic"
}

# extraArgs:
#   - --dns01-recursive-nameservers-only
#   - --dns01-recursive-nameservers=8.8.8.8:53,1.1.1.1:53