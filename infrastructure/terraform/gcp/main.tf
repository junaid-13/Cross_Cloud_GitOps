terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "network" {
  source = "./modules/gcp_network"
  project = var.project_id
  name = var.cluster_name
}

module "gke" {
  source       = "./modules/gke"
  project      = var.project_id
  name         = var.cluster_name
  region       = var.region
  zone         = var.zone
  network      = module.network.network_name
}

output "gke_cluster_name" {
  value = module.gke.cluster_name
}
output "gke_zone" {
  value = var.zone
}
output "project_id" {
  value = var.project_id
}
