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
    name: asc-gke-backup
    bucket: asc-gke-backup-bucket
  volumeSnapshotLocation:
    name: asc-gke-snapshot 

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
