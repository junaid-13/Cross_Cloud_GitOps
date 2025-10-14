module "network" {
  source = "./modules/gcp_network"
  project = var.project_id
  name = var.cluster_name
  region = var.region
}

module "gke" {
  source       = "./modules/gke"
  project      = var.project_id
  name         = var.cluster_name
  region       = var.region
  zone         = var.zone
  network      = module.network.network_name
  subnetwork   = module.network.subnetwork_name
}

