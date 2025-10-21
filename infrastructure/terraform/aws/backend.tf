terraform {
  backend "s3" {
    bucket         = "crosscloud-terraform-state"
    key            = "aws/eks/terraform.tfstate"
    region         = var.region
    encrypt        = true
    dynamodb_table = "crosscloud-terraform-locks"
  }
}