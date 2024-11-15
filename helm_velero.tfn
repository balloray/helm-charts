module "velero_chart" {
  source                  = "github.com/balloray/helm/remote/module"
  chart_name              = "velero"
  chart_path              = "velero"
  chart_version           = "3.1.4"
  chart_repo             = "https://vmware-tanzu.github.io/helm-charts"
  chart_override_values   = <<EOF
credentials:
  existingSecret: velero-secret
cleanUpCRDs: true
configuration:
  provider: gcp
  backupStorageLocation:
    default: true
    name: ${var.velero["backup_storage_location"]}
    bucket: ${var.velero["backup_storage_bucket"]}
  volumeSnapshotLocation:
    name: ${var.velero["volume_snapshot_location"]}

initContainers:
  - name: velero-plugin-for-gcp
    image: velero/velero-plugin-for-gcp:v1.6.1
    imagePullPolicy: IfNotPresent
    volumeMounts:
      - mountPath: /target
        name: plugins
EOF
  depends_on = [
    kubernetes_secret.velero_secret,
  ]
}

# Creating the secret for velero
resource "kubernetes_secret" "velero_secret" {
  metadata {
    name      = "velero-secret"
  }
  data = {
    cloud = file(pathexpand("~/velero-gcp-sa.json"))
  }
  type = "generic"
}

# ##     ## Cleanup velero-sa
# resource "null_resource" "cleanup_velero_key" {
#   depends_on = [kubernetes_secret.velero_secret]
#   provisioner "local-exec" {
#     command = <<EOF
#     #!/bin/bash
#     ## Cleanup velero-sa
#     rm -rf ~/velero-gcp-sa.txt
# EOF
#   }
# }

resource "kubernetes_cluster_role" "concourse_cluster_role" {
  metadata {
    name = "velero-role"
    labels = {
      "app" = "velero"
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
    name = "velero-rolebinding"
    labels = {
      "app" = "velero"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "velero-role"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
  }
}

## Creating the vault-setup-cm configmap for vault-setup-job to unseal the vault server after deployment
# resource "kubernetes_config_map" "velero_config_map" {
#   metadata {
#     name      = "velero-sa-cm"
#   }
#   data = {
#     "setup.sh" = file("${path.module}/terraform_templates/vault/setup.sh")
#   }
#   depends_on = [
#     module.vault_deploy,
#   ]
# }

#   - name: velero-plugin-for-gcp
#     image: velero/velero-plugin-for-gcp:v1.6.1
#     imagePullPolicy: IfNotPresent
#     volumeMounts:
#       - mountPath: /target
#         name: plugins

  # source                  = "github.com/balloray/helm/local/module"
  # chart_name              = "velero"
  # chart_path              = "./charts/velero/charts/velero"