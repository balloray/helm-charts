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

# Required provider for local files 
# provider "local" {
#   version = "1.4.0"
# }

# # We are using 2.1.2 for helm deplpoy 
# provider "template" {
#   version = "2.1.2"
# }