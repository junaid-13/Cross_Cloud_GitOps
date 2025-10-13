variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "node_group_desired_capacity" {
  type = number
}

variable "name" {
  type = string
  description = "Name prefix for VPC and subnets"
}

variable "cidr" {
  type = string
  description = "CIDR block for the VPC"
}
