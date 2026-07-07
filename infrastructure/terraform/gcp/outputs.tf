output "gke_cluster_name" {
  value = module.gke.cluster_name
}
output "gke_zone" {
  value = var.zone
}
output "project_id" {
  value = var.project_id
}