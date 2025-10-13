variable "cluster_name" {
  type = string
  description = "EKS cluster name"
}

variable "cluster_version" {
  type = string
  description = "EKS Kubernetes version"
}

variable "vpc_id" {
  type = string
  description = "VPC ID where EKS will be created"
}

variable "private_subnet_ids" {
  type = list(string)
  description = "Private subnets for worker nodes"
}

variable "public_subnet_ids" {
  type = list(string)
  description = "Public subnets for load balancers"
}

variable "node_group_desired_capacity" {
  type = number
  description = "Desired number of worker nodes"
}