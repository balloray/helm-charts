#!/bin/bash

BUCKET=gke-backups-sbx-13
PROJECT_ID=sandbox-372518
SERVICE_ACCOUNT_EMAIL=velero@sandbox-372518.iam.gserviceaccount.com


ROLE_PERMISSIONS=(compute.disks.get
    compute.disks.create
    compute.disks.createSnapshot
    compute.snapshots.get
    compute.snapshots.create
    compute.snapshots.useReadOnly
    compute.snapshots.delete
    compute.zones.get
    storage.objects.create
    storage.objects.delete
    storage.objects.get
    storage.objects.list
    iam.serviceAccounts.signBlob
)

gcloud iam roles create velero.serverz \
    --project $PROJECT_ID \
    --title "Velero Serverz" \
    --permissions "$(IFS=","; echo "${ROLE_PERMISSIONS[*]}")"    

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member serviceAccount:$SERVICE_ACCOUNT_EMAIL \
    --role projects/$PROJECT_ID/roles/velero.serverz

gsutil iam ch serviceAccount:$SERVICE_ACCOUNT_EMAIL:objectAdmin gs://${BUCKET}

gcloud iam service-accounts keys create velero-gcp-sa.txt \
    --iam-account $SERVICE_ACCOUNT_EMAIL