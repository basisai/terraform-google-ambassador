variable "project_id" {
  description = "Project ID for resources. Defaults to provider configured project"
  type        = string
  default     = null
}

variable "region" {
  description = "Region for resources. Defaults to provider configured region"
  type        = string
  default     = null
}

variable "kubernetes_namespace" {
  description = "Namespace for the Kubernetes Resources"
  type        = string
  default     = "ambassador"
}

variable "kubernetes_labels" {
  description = "Labels for the Kubernetes Resources"
  type        = map(string)
  default = {
    "app.kubernetes.io/instance"   = "ambassador"
    "app.kubernetes.io/managed-by" = "Terraform"
    "app.kubernetes.io/name"       = "ambassador"
    "app.kubernetes.io/part-of"    = "ambassador"
  }
}

variable "kubernetes_annotations" {
  description = "Annotations for Kubernetes Resources"
  type        = map(string)
  default = {
    "app.kubernetes.io/instance"   = "ambassador"
    "app.kubernetes.io/managed-by" = "Terraform"
    "app.kubernetes.io/name"       = "ambassador"
    "app.kubernetes.io/part-of"    = "ambassador"
  }
}

variable "ingress_name" {
  description = "Name of the Kubernetes Ingress"
  type        = string
  default     = "ambassador"
}

variable "ingress_annotations" {
  description = "Additional annotations for the ingress"
  type        = map(string)
  default     = {}
}

variable "external" {
  description = "Whether the ingress is external or internal."
  type        = bool
  default     = true
}

variable "allow_http" {
  description = "Allow plaintext HTTP traffic. Needs to be enabled for redirection."
  type        = bool
  default     = true
}

variable "static_ip" {
  description = "Static IP configuration"
  type = object({
    name   = string # Name to create or use
    create = bool

    description = optional(string)

    # Internal address only
    subnetwork   = optional(string) # Required for internal
    network_tier = optional(string)
    address      = optional(string) # IPv4 Address for an internal IP
  })
  default = {
    name   = "ambassadaor"
    create = true
  }
}

variable "tls_secrets" {
  description = "List of secrets to include in the ingress"
  type = list(object({
    hosts       = optional(list(string))
    secret_name = optional(string)
  }))
  default = []
}

variable "pre_shared_certificates" {
  description = "List of pre-shared certificates to use. See https://cloud.google.com/load-balancing/docs/ssl-certificates/self-managed-certs"
  type        = list(string)
  default     = []
}

variable "service_name" {
  description = "Name of Ambassador Service"
  type        = string
  default     = "ambassador"
}

variable "service_port" {
  description = "Port of Ambaassador Service"
  type        = any
  default     = 443
}

variable "managed_certificates" {
  description = "List of managed certificates to use or create. Key is the name"
  type = map(object({
    create  = optional(bool) # False by default
    domains = optional(list(string))
  }))
  default = {}
}

variable "wait_for_load_balancer" {
  description = "Wait for Load Balancer to be created successfully before returning"
  type        = bool
  default     = true
}

##############################
# Frontend Config
##############################
variable "frontend_config" {
  description = "Frontend Config CRD. Set to `null` to not use this at all"
  type = object({
    name   = string
    create = bool
  })
  default = {
    name   = "ambassador"
    create = true
  }
}

variable "ssl_policy" {
  description = "SSL Policy. Set to `null` to not use any."
  type = object({
    name   = string
    create = bool
  })
  default = {
    name   = "ambassador"
    create = true
  }
}

variable "ssl_policy_settings" {
  description = "Settings for SSL policy to create"
  type = object({
    description     = optional(string)
    profile         = optional(string)
    min_tls_version = optional(string)
    custom_features = optional(list(string))
  })
  default = {
    profile         = "MODERN"
    min_tls_version = "TLS_1_2"
  }
}

variable "ssl_redirect" {
  description = "Redirect HTTP to HTTPS"
  type = object({
    enabled            = bool
    response_code_name = optional(string) # One of `MOVED_PERMANENTLY_DEFAULT` `FOUND`, `SEE_OTHER`, `TEMPORARY_REDIRECT`, `PERMANENT_REDIRECT`
  })
  default = {
    enabled            = true
    response_code_name = "MOVED_PERMANENTLY_DEFAULT"
  }
}
