data "terraform_remote_state" "staging_vpc" {
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
