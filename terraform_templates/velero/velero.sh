#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
## Getting Google Project Id but if you have multiple projects it will get the first one 
PROJECT_ID=$(gcloud config get-value project)

# ## Creating the uniq bucket in GCP
if gsutil mb -c coldline -p "$PROJECT_ID" "gs://$1" 2> /dev/null; then
    echo "${green}The bucket <$1> has been created!!${reset}"
else
    echo "${red}The bucket already exist${reset}"
fi

## Create a service account <velero-service-account> for cluster deployment.
if gcloud iam service-accounts create velero-service-account --display-name "velero-service-account" 2> /dev/null ; then 
    echo "${green}Created service account <velero-service-account> !!${reset}"
else
    echo "${red}The service account is already exist!!${reset}"
fi 

## Getting email of the service account and binding the roles <roles>
SERVICE_ACCOUNT_EMAIL=$(gcloud iam service-accounts list --filter="displayName:velero-service-account" --format='value(email)')

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

if gcloud iam roles create velero.server --project $PROJECT_ID --title "Velero Server" --permissions "$(IFS=","; echo "${ROLE_PERMISSIONS[*]}")" 2> /dev/null ; then 
    echo "${green}Created role <velero.server > !!${reset}"
else
    echo "${red}The role is already exist!!${reset}"
fi   

## Getting email of the service account and binding the roles <roles>
SERVICE_ACCOUNT_EMAIL=$(gcloud iam service-accounts list --filter="displayName:velero-service-account" --format='value(email)')

gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SERVICE_ACCOUNT_EMAIL --role projects/$PROJECT_ID/roles/velero.server

gsutil iam ch serviceAccount:$SERVICE_ACCOUNT_EMAIL:objectAdmin gs://$1

gcloud iam service-accounts keys create velero-gcp-sa.txt --iam-account $SERVICE_ACCOUNT_EMAIL