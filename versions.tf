terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.5"
    }
  }
  required_version = ">= 0.15"

  experiments = [module_variable_optional_attrs]
}
