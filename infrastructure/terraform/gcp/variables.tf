variable "project_id" {
  description = "Google Cloud project ID where the GKE cluster and networking will be deployed."
  type        = string
}

variable "region" {
  type    = string
  default = "us-central1"
}
variable "zone" {
  type    = string
  default = "us-central1-a"
}
variable "cluster_name" {
  type    = string
  default = "crosscloud-gke"
}
