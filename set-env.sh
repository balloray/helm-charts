#!/bin/bash
DIR=$(pwd)
DATAFILE="$DIR/$1"
#

if [ ! -f "$DATAFILE" ]; then
  echo "setenv: Configuration file not found: $DATAFILE"
  return 1
fi
BUCKET=$(sed -nr 's/^gcp_bucket_name\s*=\s*"([^"]*)".*$/\1/p'             "$DATAFILE")
PROJECT=$(sed -nr 's/^gcp_project_id\s*=\s*"([^"]*)".*$/\1/p'             "$DATAFILE")
ENVIRONMENT=$(sed -nr 's/^deploy_env\s*=\s*"([^"]*)".*$/\1/p'             "$DATAFILE")
DEPLOYMENT=$(sed -nr 's/^deploy_name\s*=\s*"([^"]*)".*$/\1/p'             "$DATAFILE")
CREDENTIALS=$(sed -nr 's/^credentials\s*=\s*"([^"]*)".*$/\1/p'            "$DATAFILE") 
if [ -z "$ENVIRONMENT" ]
then
    echo "setenv: 'deploy_env' variable not set in configuration file."
    return 1
fi
if [ -z "$BUCKET" ]
then
  echo "setenv: 'google_bucket_name' variable not set in configuration file."
  return 1
fi
if [ -z "$PROJECT" ]
then
    echo "setenv: 'google_project_id' variable not set in configuration file."
    return 1
fi
if [ -z "$CREDENTIALS" ]
then
    echo "setenv: 'credentials' file not set in configuration file."
    CREDENTIALS="$HOME/google.json"
fi
if [ -z "$DEPLOYMENT" ]
then
    echo "setenv: 'deployment_name' variable not set in configuration file."
    return 1
fi
cat << EOF > "$DIR/backend.tf"
terraform {
  backend "gcs" {
    bucket  = "${BUCKET}"
    prefix  = "${ENVIRONMENT}/${DEPLOYMENT}"
  }
}
EOF
cat "$DIR/backend.tf"
GOOGLE_APPLICATION_CREDENTIALS="${CREDENTIALS}"
export GOOGLE_APPLICATION_CREDENTIALS
export DATAFILE
/bin/rm -rf "$DIR/.terraform" 2>/dev/null
/bin/rm -rf "$PWD/common_configuration.tfvars" 2>/dev/null
echo "setenv: Initializing terraform"
terraform init #> /dev/null