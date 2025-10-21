terraform {
  backend "gcs" {
    bucket = "crosscloud-terraform-state"
    prefix = "gcp/gke"
  }
}