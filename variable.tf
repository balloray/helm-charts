variable"google_project_id"{
  description ="-(Required) Google cloud platform project id."
}

variable"google_credentials_json"{
  default     ="$HOME/terraform.json"
  description ="-(Optional) The google credentials file full path."
}

variable"google_bucket_name"{
  description ="-(Required) Google cloud platform project id."
}

variable"deployment_environment"{
  default     =""
  description ="-(Optional)"
}

variable"deployment_name"{
  description ="-(Required)"
}

variable"google_domain_name"{
  description ="-(Required)"
}

variable "ingress_controller" {
  type = map

  default = {
    version        = "4.0.19"
    enabled        = "true"
    chart_repo_url = "https://kubernetes.github.io/ingress-nginx"
  }

  description = "-(Optional) The Ingress controller map configuration."
}

variable "concourse" {
  type = map

  default = {
    version             = "17.0.37"
    enabled             = "true"
    local_user          = "admin"
    admin_password      = "password"
    postgres_username   = "admin"
    postgres_password   = "password"
    chart_repo_url      = "https://concourse-charts.storage.googleapis.com"
  }

  description = "-(Required) The Grafana map configuration."
}