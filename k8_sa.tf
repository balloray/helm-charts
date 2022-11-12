## Creating the secret to access GCP 
resource "kubernetes_secret" "google_service_account" {
  metadata {
    name      = "google-service-account"
  }
  data = {
    "credentials.json" = file(pathexpand("~/google-credentials.json"))
  }
  type = "generic"
}

resource "kubernetes_service_account" "common_service_account" {
  metadata {
    name      = "common-service-account"
  }
  secret {
    name = kubernetes_secret.common_service_account_secret.metadata.0.name
  }
  automount_service_account_token = true
}

resource "kubernetes_secret" "common_service_account_secret" {
  metadata {
    name      = "common-service-account-secret"
  }
}
