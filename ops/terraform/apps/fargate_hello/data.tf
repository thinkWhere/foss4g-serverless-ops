data "terraform_remote_state" "iam_ecs" {
  # Get global ecs outputs from S3
  backend = "s3"

  config = {
    bucket                  = var.bucket
    key                     = "global/iam/terraform.tfstate"
    region                  = var.region
    shared_credentials_file = "/root/.aws/credentials"
    profile                 = var.profile
  }
}

data "terraform_remote_state" "global_vpc" {
  # Get staging VPC vars
  backend = "s3"

  config = {
    bucket                  = var.bucket
    key                     = "global/vpc/terraform.tfstate"
    region                  = var.region
    shared_credentials_file = "/root/.aws/credentials"
    profile                 = var.profile
  }
}