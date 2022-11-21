variable "gcp_domain_name" {
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
    local_users            = "admin"
    admin_password         = "password"
    postgres_username      = "admin"
    postgres_password      = "password"
    concourse_postgresql   = "concourse-postgresql"
    vault_token            = ""
    vault_creds            = ""
    # github_users           = "balloray"
    # github_clien_id        = "github_clien_id"
    # github_client_secret   = "github_client_secret"
    # host_key               = ""
    # host_key_pub           = ""
    # worker_key             = ""
    # worker_key_pub         = ""
    # sessions_signing_key   = ""
  }

  description = "-(Optional) The WikiJs map configuration."
}