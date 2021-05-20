terraform {
  required_providers {
    kubernetes-alpha = {
      source  = "hashicorp/kubernetes-alpha"
      version = ">= 0.2"
    }
  }
  required_version = ">= 0.14"

  experiments = [module_variable_optional_attrs]
}
