google_domain_name       = "balloray.com"
google_project_id        = "sandbox-366619"
google_bucket_name       = "sandbox-13-bucket"
deployment_environment   = "sbx"
deployment_name          = "platf-tools"


concourse = {
    version                = "17.0.37"
    enabled                = "true"
    local_user             = "admin"
    admin_password         = "password"
    postgres_username      = "admin"
    postgres_password      = "password"
    concourse_postgresql   = "concourse-postgresql"
    chart_repo_url      = "https://concourse-charts.storage.googleapis.com"
}
