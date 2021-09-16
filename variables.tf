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

variable "release_name" {
  description = "Chart release name"
  type        = string
  default     = "ambassador"
}

variable "chart_namespace" {
  description = "Namespace to run the chart in"
  type        = string
  default     = "ambassador"
}

variable "chart_version" {
  description = "Version of Chart to install. Set to empty to install the latest version"
  type        = string
  default     = "6.7.2"
}

variable "crds_enable" {
  description = "Enable CRDs"
  type        = bool
  default     = true
}

variable "crds_create" {
  description = "Create CRDs"
  type        = bool
  default     = true
}

variable "crds_keep" {
  description = "Keep CRDs"
  type        = bool
  default     = true
}

variable "image_repository" {
  # One of
  # docker.io/datawire/ambassador
  # quay.io/datawire/ambassador
  # gcr.io/datawire/ambassador
  description = "Image repository for Ambassador image"
  type        = string
  default     = "quay.io/datawire/ambassador"
}

variable "image_tag" {
  description = "Image tag for Ambassador image"
  type        = string
  default     = "1.13.9"
}

variable "replicas" {
  description = "Number of replicas"
  default     = 3
}

variable "hpa_enabled" {
  description = "Enable HPA"
  type        = bool
  default     = true
}

variable "hpa_min_replica" {
  description = "Minimum Number of replica"
  type        = number
  default     = 2
}

variable "hpa_max_replica" {
  description = "Max Number of replica"
  type        = number
  default     = 3
}

variable "hpa_metrics" {
  description = "Metrics for HPA Scaling"
  type        = any
  default = [
    {
      type = "Resource"
      resource = {
        name = "cpu"
        target = {
          type               = "Utilization"
          averageUtilization = 80
        }
      }
    },
    {
      type = "Resource"
      resource = {
        name = "memory"
        target = {
          type               = "Utilization"
          averageUtilization = 80
        }
      }
    },
  ]
}

variable "pod_disruption_budget" {
  description = "PDB values"
  type        = any
  default = {
    minAvailable = 1
  }
}

variable "resources" {
  description = "Pod resources"
  type        = any
  default = {
    requests = {
      cpu    = "200m"
      memory = "1500Mi"
    }
    limits = {
      cpu    = "1000m"
      memory = "1500Mi"
    }
  }
}

variable "priority_class_name" {
  description = "Priority class names"
  type        = string
  default     = ""
}

variable "affinity" {
  description = "Pod Affinity"
  type        = any
  default     = {}
}

variable "tolerations" {
  description = "Pod Tolerations"
  type        = list(any)
  default     = []
}

variable "labels" {
  description = "Labels for resources"
  type        = map(string)
  default = {
    "app.kubernetes.io/managed-by" = "Terraform"
  }
}

variable "env" {
  description = "Environment variables for container"
  type        = map(string)
  default     = {}
}

variable "env_raw" {
  description = "Raw environment variables for container"
  type        = list(any)
  default     = []
}

variable "pod_security_context" {
  description = "Pod securityContext"
  type        = any
  default     = {}
}

variable "container_security_context" {
  description = "Container securityContext"
  type        = any
  default     = {}
}

variable "volumes" {
  description = "Volumes for containers"
  type        = list(any)
  default     = []
}

variable "volume_mounts" {
  description = "Volumes mounts for container"
  type        = list(any)
  default     = []
}

variable "ambassador_id" {
  description = "Ambassador ID"
  type        = string
  default     = "default"
}

variable "ambassador_configurations" {
  description = "Configuration options for Ambassador. See https://www.getambassador.io/docs/edge-stack/latest/topics/running/ambassador/"
  type        = any
  default = {
    diagnostics = {
      enabled = false
    }
  }
}

##########################################
# Ambassador Edge Stack Configuration
##########################################
variable "enable_aes" {
  description = "Enable Edge Stack"
  default     = false
}

variable "license_key" {
  description = "License key for AES"
  default     = ""
}

variable "license_key_create_secret" {
  description = "Create secret for license key"
  default     = true
}

variable "license_key_secret_name" {
  description = "Secret name for license"
  default     = ""
}

variable "license_key_secret_annotations" {
  description = "License key secret annotations"
  default     = {}
}

variable "create_dev_portal_mappings" {
  description = "# The DevPortal is exposed at /docs/ endpoint in the AES container. Setting this to true will automatically create routes for the DevPortal."
  default     = true
}

variable "redis_url" {
  description = "Custom Redis URL"
  default     = ""
}

variable "redis_create" {
  description = "Create Redis"
  default     = true
}

variable "redis_image" {
  description = "Redis image"
  default     = "redis"
}

variable "redis_tag" {
  description = "Redis image tag"
  default     = "5.0.1"
}

variable "redis_deployment_annotations" {
  description = "Redis deployment annotations"
  default     = {}
}

variable "redis_service_annotations" {
  description = "Redis service annotations"
  default     = {}
}

variable "redis_resources" {
  description = "Redis resources"
  default     = {}
}

variable "redis_affinity" {
  description = "Affinity for redis pods"
  default     = {}
}

variable "redis_tolerations" {
  description = "Redis tolerations"
  default     = []
}

variable "auth_service_create" {
  description = "Deploy AuthService"
  default     = true
}

variable "auth_service_config" {
  description = "Configuration for AuthService"
  default     = {}
}

variable "rate_limit_create" {
  description = "Create the RateLimitService"
  default     = true
}

variable "registry_create" {
  description = "Enable Projects beta feature"
  default     = false
}

##########################################
# Service
##########################################
variable "enable_l7_load_balancing" {
  description = "Use L7 for load balancing. Otherwise, L4 is used"
  type        = bool
  default     = true
}

variable "internet_facing" {
  description = "Whether the Load Balancer, L7 or L4 is internet facing"
  type        = bool
  default     = true
}

variable "service_annotations" {
  description = "Additional annotations for the service"
  type        = map(string)
  default     = {}
}

variable "load_balancer_source_ranges" {
  description = "Load balancer source range for L4 Load balancing"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "external_traffic_policy" {
  description = "External traffic policy for L4 Load balancing"
  type        = string
  default     = "Local"
}

variable "admin_service_annotations" {
  description = "Annotations for the admin service"
  type        = map(string)
  default = {
    "prometheus.io/scrape" = "true"
  }
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

variable "http2_enable" {
  description = "Use HTTP/2. See https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-http2"
  type        = bool
  default     = true
}

variable "wait_for_load_balancer" {
  description = "Wait for Load Balancer to be created successfully before returning"
  type        = bool
  default     = true
}

################################
# CRD Configuration
################################
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

################################
# FrontendConfig
################################
variable "ingress_name" {
  description = "Name of the Kubernetes Ingress"
  type        = string
  default     = ""
}

variable "ingress_annotations" {
  description = "Additional annotations for the ingress"
  type        = map(string)
  default     = {}
}

variable "allow_http" {
  description = "Allow plaintext HTTP traffic. Needs to be enabled for redirection."
  type        = bool
  default     = true
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

variable "frontend_config" {
  description = "Frontend Config CRD name"
  type        = string
  default     = ""
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

################################
# BackendConfig
################################
variable "backend_config" {
  description = "Name for the BackendConfig CRD. Defaults to chart release name"
  type        = string
  default     = ""
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
