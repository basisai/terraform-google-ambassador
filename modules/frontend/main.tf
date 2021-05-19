resource "kubernetes_ingress" "ingress" {
  depends_on = [
    kubernetes_manifest.managed_certificates,
  ]

  wait_for_load_balancer = true

  metadata {
    name      = var.ingress_name
    namespace = var.kubernetes_namespace
    labels    = var.kubernetes_labels

    # See https://cloud.google.com/kubernetes-engine/docs/how-to/load-balance-ingress#ingress_annotations
    # and https://cloud.google.com/kubernetes-engine/docs/how-to/internal-load-balance-ingress#summary_of_internal_ingress_annotations
    annotations = merge(
      {
        for k, v in {
          "kubernetes.io/ingress.class"      = var.external ? "gce" : "gce-internal"
          "kubernetes.io/ingress.allow-http" = tostring(var.allow_http)

          "kubernetes.io/ingress.global-static-ip-name"   = var.external ? coalescelist(google_compute_address.internal.*.name, [var.static_ip.name])[0] : null
          "kubernetes.io/ingress.regional-static-ip-name" = !var.external ? coalescelist(google_compute_global_address.external.*.name, [var.static_ip.name])[0] : null

          "ingress.gcp.kubernetes.io/pre-shared-cert" = length(var.pre_shared_certificates) > 0 ? join(",", var.pre_shared_certificates) : null
          "networking.gke.io/managed-certificates"    = length(var.managed_certificates) > 0 ? join(",", keys(var.managed_certificates)) : null

          "networking.gke.io/v1beta1.FrontendConfig" = var.external && var.frontend_config != null ? coalescelist(kubernetes_manifest.frontend_config.*.manifest.metadata.name, [var.frontend_config.name])[0] : null
        } : k => v if v != null && v != ""
      },
      var.ingress_annotations,
    )
  }

  spec {
    dynamic "tls" {
      for_each = var.tls_secrets
      content {
        hosts       = tls.value.hosts
        secret_name = tls.value.secret_name
      }
    }

    rule {
      http {
        path {
          path = "/*"
          backend {
            service_name = var.service_name
            service_port = var.service_port
          }
        }
      }
    }
  }
}
