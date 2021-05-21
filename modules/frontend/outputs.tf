output "ip_address" {
  description = "IP Address for the endpoint"
  value       = coalescelist(data.google_compute_address.internal.*.address, data.google_compute_global_address.external.*.address)[0]
}
