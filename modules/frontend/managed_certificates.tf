resource "kubernetes_manifest" "managed_certificates" {
  provider = kubernetes-alpha
  for_each = { for k, v in var.managed_certificates : k => v if coalesce(v.create, false) }

  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "ManagedCertificate"

    metadata = {
      name      = each.key
      namespace = var.kubernetes_namespace
      labels    = var.kubernetes_labels
    }

    spec = {
      domains = each.value.domains
    }
  }
}
