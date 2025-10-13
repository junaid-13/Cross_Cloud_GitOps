output "eks_cluster_name" {
  value = module.eks.cluster_name
}
output "region" {
  description = "AWS region used for this deployment"
  value       = var.region
}