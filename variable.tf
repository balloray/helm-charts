# variable"google_project_id"{
#   description ="-(Required) Google cloud platform project id."
# }

# variable"google_credentials_json"{
#   default     ="$HOME/terraform.json"
#   description ="-(Optional) The google credentials file full path."
# }

# variable"google_bucket_name"{
#   description ="-(Required) Google cloud platform project id."
# }

# variable"deployment_environment"{
#   default     =""
#   description ="-(Optional)"
# }

# variable"deployment_name"{
#   description ="-(Required)"
# }

# variable"google_domain_name"{
#   description ="-(Required)"
# }

# variable "ingress_controller" {
#   type = map

#   default = {
#     version        = "4.0.19"
#     enabled        = "true"
#     chart_repo_url = "https://kubernetes.github.io/ingress-nginx"
#   }

#   description = "-(Optional) The Ingress controller map configuration."
# }

# variable "concourse" {
#   type = map

#   default = {
#     version                = "17.0.37"
#     enabled                = "true"
#     local_user             = "admin"
#     admin_password         = "password"
#     postgres_username      = "admin"
#     postgres_password      = "password"
#     concourse_postgresql   = "concourse-postgresql"
#     vault_token            = "s.mSNnbhGAqxK2ZbMasOQ91rIA"
#     chart_repo_url         = "https://concourse-charts.storage.googleapis.com"
#   }

#   description = "-(Required) The Grafana map configuration."
# }

variable "deployment_endpoint" {
  description = "-(Optional) Endpoint for the application"
  default     = "example.local"
}

variable "deployment_name" {
  description = "-(Required) The name of the deployment"
}

variable "deployment_environment" {
  description = "-(Required) The name of the environment"
}

variable "deployment_path" {
  description = "-(Required) Chart location or chart name <stable/example>"
}

variable "release_version" {
  description = "-(Optional) Specify the exact chart version to install"
  default     = "0.1.0"
}

variable "remote_chart" {
  type        = bool
  default     = false
  description = "-(Optional) For the remote charts set to <true>"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "-(Optional) deployment can be disabled or enabled by using this bool!"
}

variable "template_custom_vars" {
  type        = map
  default     = {}
  description = "-(Optional) Local chart replace variables from values.yaml"
}

variable "trigger" {
  default = "UUID"
}

variable "timeout" {
  default = "400"
}

variable "recreate_pods" {
  type        = bool
  default     = false
}

variable "values" {
  default     = "values.yaml"
  description = "-(Optional) Local chart <values.yaml> location"
}

variable "remote_override_values" {
  default     = ""
  description = "-(Optional)"
}

variable "chart_repo" {
  default     = ""
  description = "-(Optional) Provide the remote helm charts repository."
}