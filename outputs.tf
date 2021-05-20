output "ip_address" {
  description = "IP Address of the deployed endpoint"
  value       = var.enable_l7_load_balancing ? module.frontend[0].ip_address : data.google_compute_address.l4[0].address
}
