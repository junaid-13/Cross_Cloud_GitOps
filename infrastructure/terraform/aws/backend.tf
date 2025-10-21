terraform {
  backend "s3" {
    bucket         = "crosscloud-terraform-state"
    key            = "aws/eks/terraform.tfstate"
    region         = us-east-1
    encrypt        = true
    dynamodb_table = "crosscloud-terraform-locks"
  }
}
