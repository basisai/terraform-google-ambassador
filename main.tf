module "helm" {
  source  = "basisai/ambassador/helm"
  version = "~> 0.1.0, >= 0.1.1"

  release_name    = var.release_name
  chart_namespace = var.chart_namespace
  chart_version   = var.chart_version

  crds_enable = var.crds_enable
  crds_create = var.crds_create
  crds_keep   = var.crds_keep

  image_repository = var.image_repository
  image_tag        = var.image_tag

  replicas              = var.replicas
  hpa_enabled           = var.hpa_enabled
  hpa_min_replicas      = var.hpa_min_replica
  hpa_max_replicas      = var.hpa_max_replica
  hpa_metrics           = var.hpa_metrics
  pod_disruption_budget = var.pod_disruption_budget

  env = merge(
    { AMBASSADOR_ID = var.ambassador_id },
    var.env,
  )
  env_raw = var.env_raw

  pod_security_context       = var.pod_security_context
  container_security_context = var.container_security_context

  volumes       = var.volumes
  volume_mounts = var.volume_mounts

  service_type = var.enable_l7_load_balancing ? "NodePort" : "LoadBalancer"
  # See https://cloud.google.com/kubernetes-engine/docs/how-to/load-balance-ingress#service_annotations_related_to_ingress
  service_annotations = merge(
    var.service_annotations,
    var.enable_l7_load_balancing ? {
      "cloud.google.com/neg" = jsonencode({
        ingress = true
      })
      "cloud.google.com/app-protocols" = jsonencode({
        https = var.http2_enable ? "HTTP2" : "HTTPS" # HTTP2 for HTTP/2 and GRPC. HTTPS for TLS with HTTP/1.1
        http  = "HTTP"
      })
      "cloud.google.com/backend-config" = jsonencode({
        default = module.backend_config[0].backend_config
      })
      } : {
      "cloud.google.com/load-balancer-type" = var.internet_facing ? "External" : "Internal"
    },
    {
      "getambassador.io/config" = yamlencode({
        apiVersion    = "ambassador/v1"
        kind          = "Module"
        name          = "ambassador"
        ambassador_id = var.ambassador_id
        config = merge(
          {
            xff_num_trusted_hops = var.enable_l7_load_balancing ? 1 : 0
            use_remote_address   = !var.enable_l7_load_balancing
          },
          var.ambassador_configurations,
        )
      })
    }
  )

  load_balancer_ip            = !var.enable_l7_load_balancing ? data.google_compute_address.l4[0].address : ""
  load_balancer_source_ranges = !var.enable_l7_load_balancing ? var.load_balancer_source_ranges : []
  external_traffic_policy     = var.external_traffic_policy

  admin_service_annotations = var.admin_service_annotations

  resources           = var.resources
  priority_class_name = var.priority_class_name
  tolerations         = var.tolerations
  affinity = merge({
    podAntiAffinity = {
      requiredDuringSchedulingIgnoredDuringExecution = [
        {
          labelSelector = {
            matchLabels = {
              "app.kubernetes.io/name"     = "ambassador"
              "app.kubernetes.io/instance" = var.release_name
            }
          }
          topologyKey = "kubernetes.io/hostname"
        }
      ]
      preferredDuringSchedulingIgnoredDuringExecution = [
        {
          podAffinityTerm = {
            labelSelector = {
              matchLabels = {
                "app.kubernetes.io/name"     = "ambassador"
                "app.kubernetes.io/instance" = var.release_name
              }
            }
            topologyKey = "topology.kubernetes.io/zone"
          }
          weight = 100
        }
      ]
    }
  }, var.affinity)

  ##########################################
  # Ambassador Edge Stack Configuration
  ##########################################
  enable_aes                     = var.enable_aes
  license_key                    = var.license_key
  license_key_create_secret      = var.license_key_create_secret
  license_key_secret_name        = var.license_key_secret_name
  license_key_secret_annotations = var.license_key_secret_annotations
  create_dev_portal_mappings     = var.create_dev_portal_mappings
  redis_url                      = var.redis_url
  redis_create                   = var.redis_create
  redis_image                    = var.redis_image
  redis_tag                      = var.redis_tag
  redis_deployment_annotations   = var.redis_deployment_annotations
  redis_service_annotations      = var.redis_service_annotations
  redis_resources                = var.redis_resources
  redis_affinity                 = var.redis_affinity
  redis_tolerations              = var.redis_tolerations
  auth_service_create            = var.auth_service_create
  auth_service_config            = var.auth_service_config
  rate_limit_create              = var.rate_limit_create
  registry_create                = var.registry_create
}
