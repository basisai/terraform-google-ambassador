module "helm" {
  source  = "basisai/ambassador/helm"
  version = "~> 1.0.0-alpha1"

  release_name    = var.release_name
  chart_namespace = var.chart_namespace
  chart_version   = var.chart_version

  manage_crd   = var.manage_crd
  crd_manifest = var.crd_manifest

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

  create_default_listeners = var.create_default_listeners

  service_type = var.enable_l7_load_balancing ? "ClusterIP" : "LoadBalancer"
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
  external_traffic_policy     = !var.enable_l7_load_balancing ? var.external_traffic_policy : ""

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
}
