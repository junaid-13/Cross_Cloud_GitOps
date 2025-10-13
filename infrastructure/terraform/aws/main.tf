module "vpc" {
  source = "./modules/aws_network"
  name   = var.cluster_name
  cidr   = var.vpc_cidr
}

module "eks" {
  source                     = "./modules/aws_eks"
  cluster_name               = var.cluster_name
  cluster_version            = var.cluster_version
  vpc_id                     = module.vpc.vpc_id
  private_subnet_ids         = module.vpc.private_subnet_ids
  public_subnet_ids          = module.vpc.public_subnet_ids
  node_group_desired_capacity = var.node_group_desired_capacity
}
