terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.6.0"
    }
  }
  required_version = ">= 0.15"

  experiments = [module_variable_optional_attrs]
}
