data "terraform_remote_state" "global_geoserver_ecs" {
  # Get global ecs outputs from S3
  backend = "s3"

  config = {
    bucket                  = var.bucket
    key                     = "apps/geoserver/global/terraform.tfstate"
    region                  = var.region
    shared_credentials_file = "/root/.aws/credentials"
    profile                 = var.profile
  }
}