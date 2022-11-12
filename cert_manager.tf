module "cert_manager_chart" {
  source                  = "github.com/balloray/helm-chart/module"
  chart_name              = "cert-manager"
  chart_path              = "cert-manager"
  chart_version           = "1.7.2"
  chart_repo              = "https://charts.jetstack.io"
  chart_override_values   = <<EOF
installCRDs: true
EOF
}

# data "template_file" "cert_manager_cluster_issuer" {
#   template = file("tf-templates/cert-manager/issuer.yaml")

#   # vars = {
#   #   google_project_id   = var.google_project_id
#   #   clusterissuer_email = var.email
#   # }
# }


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
