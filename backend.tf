terraform {
  backend "gcs" {
    bucket  = "balloray14-bucket"
    prefix  = "default/platf-tools"
  }
}
