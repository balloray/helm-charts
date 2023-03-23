variable "gcp_zone_name" {
  description = "the name of the domain"
  type        = string
  default     = "example.com"
}

variable "gcp_project_id" {
  description = "(Optional) project where VPC will be created"
  type        = string
  default     = "get-from-console"
}

variable "gcp_bucket_name" {
  description = "- (Required) Google Bucket to store the state file!"
  type        = string
  default     = "example-bucket"
}

variable "deploy_env" {
  description = "(Required) Part of the prefix of the state file path!"
  type        = string
  default     = "default"
}

variable "deploy_name" {
  description = "the name of the deployment"
  type        = string
  default     = "example-vpc"
}

variable "google_credentials_json" {
  default     = "~/google.json"
  description = "(Optional) Google Service account Json file."
}

variable "timeout" {
  default = "400"
}

variable "recreate_pods" {
  type        = bool
  default     = false
}

variable "concourse" {
  type = map
  default = {
    local_admin            = "admin"
    admin_password         = "password"
    postgres_user          = "admin"
    postgres_passwd        = "password"
    postgres_db            = "concourse-postgresql"
    github_users           = "balloray"
    github_client_id       = "github-client-id"
    github_client_secret   = "github-client-secret"
    vault_creds            = ""
    credhub_id             = ""
    credhub_secret         = ""
    # vault_token            = ""
  }
  description = "-(Optional) The WikiJs map configuration."
}

variable "velero" {
  type = map
  default = {
    backup_storage_location    = "backup"
    backup_storage_bucket      = "bucket"
    volume_snapshot_location   = "location"
  }
  description = "-(Optional) The WikiJs map configuration."
}