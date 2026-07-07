resource "google_project_service" "compute_api" {
  project = var.project
  service = "compute.googleapis.com"

  disable_on_destroy = false
}

# Create a custom VPC
resource "google_compute_network" "vpc" {
  name                    = var.name
  project                 = var.project
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"

  depends_on = [google_project_service.compute_api]
}

# Create one or more subnets in the chosen region
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.name}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project

  private_ip_google_access = true
}
