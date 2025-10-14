resource "google_container_cluster" "primary" {
  name                     = var.name
  location                 = var.zone
  network                  = var.network
  subnetwork               = var.subnetwork
  remove_default_node_pool = true
  initial_node_count       = 1
  project                  = var.project

  # Enable VPC-native (recommended)
  ip_allocation_policy {}

  # Enable basic security
  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "${var.project}.svc.id.goog"
  }

  # Optional - enable logging & monitoring
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  depends_on = [google_project_service.container_api]
}

# Enable GKE API if not already enabled
resource "google_project_service" "container_api" {
  project = var.project
  service = "container.googleapis.com"

  disable_on_destroy = false
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.name}-pool"
  cluster    = google_container_cluster.primary.name
  location   = var.zone
  node_count = 2
  project    = var.project

  node_config {
    preemptible  = false
    machine_type = "e2-medium"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = {
      environment = "dev"
    }

    tags = ["gke-node", var.name]
  }

  depends_on = [google_container_cluster.primary]
}
