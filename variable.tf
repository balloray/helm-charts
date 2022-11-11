variable "google_bucket_name" {
  description = "-(Required) The name of the deployment"
}

variable "google_domain_name" {
  description = "-(Required) The name of the deployment"
}

variable "google_project_id" {
  description = "-(Required) The name of the deployment"
}

variable "deployment_name" {
  description = "-(Required) The name of the deployment"
}

variable "deployment_environment" {
  description = "-(Required) The name of the environment"
  default     = "sbx"
}

variable "deployment_endpoint" {
  description = "-(Optional) Endpoint for the application"
  default     = "example.local"
}

variable "chart_name" {
  description = "-(Required) The name of the deployment"
  default     = "concourse"
}

variable "deployment_path" {
  default     = "concourse"
  description = "-(Required) Chart location or chart name <stable/example>"
}

variable "release_version" {
  description = "-(Optional) Specify the exact chart version to install"
  default     = "17.0.37"
}

variable "timeout" {
  default = "400"
}

variable "recreate_pods" {
  type        = bool
  default     = false
}

# variable "chart_repo" {
#   default     = "https://concourse-charts.storage.googleapis.com"
#   description = "-(Optional) Provide the remote helm charts repository."
# }

variable "chart_override_values" {
  description = "-(Optional)"
  default     = <<EOF
google
EOF
}

variable "concourse" {
  type = map

  default = {
    vault_token            = "admin"
    local_user             = "admin"
    admin_password         = "password"
    postgres_username      = "admin"
    postgres_password      = "password"
    concourse_postgresql   = "concourse-postgresql"
  }

  description = "-(Optional) The WikiJs map configuration."
}
