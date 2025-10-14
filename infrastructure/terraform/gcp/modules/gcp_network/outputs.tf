output "network_name" {
  description = "VPC network name"
  value       = google_compute_network.vpc.name
}

output "subnetwork_name" {
  description = "Subnetwork name"
  value       = google_compute_subnetwork.subnet.name
}
