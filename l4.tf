resource "google_compute_address" "l4" {
  count = !var.enable_l7_load_balancing && var.static_ip.create ? 1 : 0

  name         = var.static_ip.name
  address_type = var.internet_facing ? "EXTERNAL" : "INTERNAL"
  subnetwork   = var.static_ip.subnetwork

  description  = var.static_ip.description
  address      = var.static_ip.address
  network_tier = var.static_ip.network_tier

  project = var.project_id
  region  = var.region
}

data "google_compute_address" "l4" {
  count      = !var.enable_l7_load_balancing ? 1 : 0
  depends_on = [google_compute_address.l4]

  name = var.static_ip.name

  project = var.project_id
  region  = var.region
}
