terraform {
  backend "gcs" {
    bucket  = "sandbox-13-bucket"
    prefix  = "sbx/platf-tools"
  }
}
