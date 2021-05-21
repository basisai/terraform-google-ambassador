module "backend_config" {
  count = var.enable_l7_load_balancing ? 1 : 0

  source = "./modules/backend"

  backend_config       = coalesce(var.backend_config, var.release_name)
  kubernetes_namespace = var.chart_namespace
  kubernetes_labels    = var.kubernetes_labels

  timeout_sec                     = var.timeout_sec
  cdn                             = var.cdn
  connection_draining_timeout_sec = var.connection_draining_timeout_sec
  health_check                    = var.health_check
  cloud_armor_policy              = var.cloud_armor_policy
  logging                         = var.logging
  iap                             = var.iap
  session_affinity                = var.session_affinity
  custom_request_headers          = var.custom_request_headers
}

module "frontend" {
  count = var.enable_l7_load_balancing ? 1 : 0

  source = "./modules/frontend"

  project_id           = var.project_id
  region               = var.region
  kubernetes_namespace = var.chart_namespace
  kubernetes_labels    = var.kubernetes_labels

  ingress_name        = coalesce(var.ingress_name, var.release_name)
  ingress_annotations = var.ingress_annotations
  external            = var.internet_facing

  static_ip               = var.static_ip
  allow_http              = var.allow_http
  tls_secrets             = var.tls_secrets
  pre_shared_certificates = var.pre_shared_certificates
  service_name            = var.service_name
  service_port            = var.service_port
  managed_certificates    = var.managed_certificates

  frontend_config = {
    name   = coalesce(var.frontend_config, var.release_name)
    create = true
  }

  ssl_policy          = var.ssl_policy
  ssl_policy_settings = var.ssl_policy_settings
  ssl_redirect        = var.ssl_redirect

  wait_for_load_balancer = var.wait_for_load_balancer
}
