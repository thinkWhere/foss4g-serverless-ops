# Terraform AWS provider config.  Must be initialised with tfinit
provider "aws" {
  version                 = "~> 2.14"
  region                  = var.region
  shared_credentials_file = "/root/.aws/credentials"
  profile                 = var.profile
}

# Location of shared state in S3 for this module.  EDIT WITH EXTREME CAUTION!!
terraform {
  backend "s3" {
    key                     = "apps/horizon_app/app/terraform.tfstate"
    shared_credentials_file = "/root/.aws/credentials"
  }
}
