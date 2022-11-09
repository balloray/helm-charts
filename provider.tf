# required helm provider for this module 
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
  #version = "1.3.2" #previous version was "0.10.6"
}

provider "kubernetes" {
  #version = "1.3.2" #previous version was "0.10.6"
  config_path = "~/.kube/config"
}