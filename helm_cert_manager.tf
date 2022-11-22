module "cert_manager_chart" {
  source                  = "github.com/balloray/helm-chart/module"
  chart_name              = "cert-manager"
  chart_path              = "cert-manager"
  chart_version           = "1.7.2"
  chart_repo              = "https://charts.jetstack.io"
  chart_override_values   = <<EOF
installCRDs: true
extraArgs:
  - --dns01-recursive-nameservers-only
  - --dns01-recursive-nameservers=8.8.8.8:53,1.1.1.1:53
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


