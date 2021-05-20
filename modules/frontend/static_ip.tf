resource "google_compute_address" "internal" {
  count = !var.external && var.static_ip.create ? 1 : 0

  name         = var.static_ip.name
  address_type = "INTERNAL"
  subnetwork   = var.static_ip.subnetwork

  description  = var.static_ip.description
  address      = var.static_ip.address
  network_tier = var.static_ip.network_tier

  project = var.project_id
  region  = var.region
}

resource "google_compute_global_address" "external" {
  count = var.external && var.static_ip.create ? 1 : 0

  name         = var.static_ip.name
  address_type = "EXTERNAL"

  description = var.static_ip.description

  project = var.project_id
}
