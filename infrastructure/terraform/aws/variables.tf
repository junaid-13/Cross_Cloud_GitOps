variable "region" {
  type    = string
  default = "us-east-1"
}
variable "cluster_name" {
  type    = string
  default = "crosscloud-eks"
}
variable "cluster_version" {
  type    = string
  default = "1.29"
}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "node_group_desired_capacity" {
  type    = number
  default = 2
}
