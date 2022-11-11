module "concourse_chart" {
  source                  = "github.com/balloray/helm-chart/module"
  chart_name              = "concourse"
  chart_path              = "concourse"
  chart_version           = "17.0.37"
  chart_repo              = "https://concourse-charts.storage.googleapis.com"
  chart_override_values   = <<EOF
installCRDs: true
EOF
}

data "template_file" "cert_manager_cluster_issuer" {
  template = file("tf-templates/cert-manager/issuer.yaml")

  # vars = {
  #   google_project_id   = var.google_project_id
  #   clusterissuer_email = var.email
  # }
}


## Creating the cluster issuer for cert manager
resource "null_resource" "cert_manager_cluster_issuer" {
  provisioner "local-exec" {
    command = <<EOF
    #!/bin/bash
    ## Waiting until the cluster issuer can be created
    while ! kubectl get clusterissuer &> /dev/null 
    do
      echo 'Waiting until Custom Resource Definitions are ready!!'
      sleep 1
    done
    ## Creating the cluster issuer
    echo "${data.template_file.cert_manager_cluster_issuer.rendered} "> terraform_templates/cert-manager/cluster-issuer-prod-ignoreme.yaml
    kubectl apply --validate=false -f terraform_templates/cert-manager/cluster-issuer-prod-ignoreme.yaml
EOF
  }
  depends_on = [
    module.cert_manager_deploy,
  ]
}
