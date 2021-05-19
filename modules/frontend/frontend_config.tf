# See https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-features#configuring_ingress_features_through_frontendconfig_parameters
resource "google_compute_ssl_policy" "this" {
  count = try(var.ssl_policy.create, false) ? 1 : 0

  name    = var.ssl_policy.name
  project = var.project_id

  description     = var.ssl_policy_settings.description
  profile         = var.ssl_policy_settings.profile
  min_tls_version = var.ssl_policy_settings.min_tls_version
  custom_features = var.ssl_policy_settings.custom_features
}

resource "kubernetes_manifest" "frontend_config" {
  provider = kubernetes-alpha
  count    = try(var.frontend_config.create, false) ? 1 : 0

  manifest = {
    apiVersion = "networking.gke.io/v1beta1"
    kind       = "FrontendConfig"

    metadata = {
      name      = var.frontend_config.name
      namespace = var.kubernetes_namespace
      labels    = var.kubernetes_labels
    }

    spec = {
      sslPolicy = coalescelist(google_compute_ssl_policy.this.*.name, [var.ssl_policy.name], [""])[0]

      redirectToHttps = {
        enabled          = var.ssl_redirect.enabled
        responseCodeName = var.ssl_redirect.response_code_name
      }
    }
  }
}
