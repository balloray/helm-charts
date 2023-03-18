module "velero_chart" {
  source                  = "github.com/balloray/helm/local/module"
  chart_name              = "velero"
  chart_path              = "./charts/velero/charts/velero"
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
}
# Creating the secret for velero
resource "kubernetes_secret" "velero_secret" {
  metadata {
    name      = "velero-secret"
  }
  data = {
    cloud = file(pathexpand("~/velero-gcp-sa.txt"))
  }
  type = "generic"
}