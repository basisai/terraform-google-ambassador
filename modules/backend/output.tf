output "backend_config" {
  description = "Name of the BackendConfig created"
  value       = kubernetes_manifest.backend_config.manifest.metadata.name
}
