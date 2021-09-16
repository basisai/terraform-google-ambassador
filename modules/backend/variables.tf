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

variable "backend_config" {
  description = "Name for the BackendConfig CRD"
  type        = string
  default     = "ambassador"
}

variable "timeout_sec" {
  description = "Configures the backend service timeout. See https://cloud.google.com/load-balancing/docs/backend-service#timeout-setting"
  type        = number
  default     = 30
}

variable "cdn" {
  description = "Enable Cloud CDN"
  type = object({
    enabled = bool
    # See https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-features#configuring_ingress_features_through_backendconfig_parameters
    policy = optional(object({
      include_host           = optional(bool)
      include_protocol       = optional(bool)
      include_query_string   = optional(bool)
      query_string_blacklist = optional(list(string))
      query_string_whitelist = optional(list(string))
    }))
  })
  default = {
    enabled = false
  }
}

variable "connection_draining_timeout_sec" {
  description = "connection draining timeout is the time, in seconds, to wait for connections to drain"
  type        = number
  default     = 0
}

variable "health_check" {
  description = "Health Check Configuration"
  type = object({
    interval            = optional(number)
    timeout             = optional(number)
    health_threshold    = optional(number)
    unhealthy_threshold = optional(number)
    protocol            = optional(string)
    path                = optional(string)
    port                = optional(number)
  })
  default = {
    interval = 10
    timeout  = 10
    port     = 8877
    protocol = "HTTP"
    path     = "/ambassador/v0/check_alive"
  }
}

variable "cloud_armor_policy" {
  description = "Name of the Cloud Armor Policy to use"
  type        = string
  default     = ""
}

variable "logging" {
  description = "Logging configuration for the endpoint"
  type = object({
    enable      = bool
    sample_rate = number
  })
  default = {
    enable      = false
    sample_rate = 0.5
  }
}

variable "iap" {
  description = "Enable Identity-Aware Proxy by setting the secret name with the OAuth Client Credentials"
  type        = string
  default     = ""
}

variable "session_affinity" {
  description = "Session affinity. Set type to empty to disable"
  type = object({
    type           = string
    cookie_ttl_sec = optional(number)
  })
  default = {
    type = ""
  }
}

variable "custom_request_headers" {
  description = "Map of Custom Request Headers"
  type        = map(string)
  default     = {}
}
