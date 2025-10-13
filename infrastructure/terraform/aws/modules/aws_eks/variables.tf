variable "cluster_name" {}
variable "cluster_version" {}
variable "private_subnet_ids" { type = list(string) }
variable "public_subnet_ids" { type = list(string) }
variable "node_group_desired_capacity" { type = number }
