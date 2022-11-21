variable "gcp_domain_name" {
  description = "-(Required) The name of the deployment"
}

variable "gcp_project_id" {
  description = "-(Required) The name of the deployment"
}

variable "gcp_bucket_name" {
  description = "-(Required) The name of the deployment"
}

variable "deploy_env" {
  description = "-(Required) The name of the environment"
  default     = "default"
}

variable "deploy_name" {
  description = "-(Required) The name of the deployment"
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