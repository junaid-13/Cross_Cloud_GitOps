output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_region" {
  value = module.eks.region
}

output "network_region" {
  value = module.vpc.region
}