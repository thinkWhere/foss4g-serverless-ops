###########
# Config
###########

variable "region" {
  description = "AWS region we're operating in, read from TF_VAR_region env var"
}

variable "profile" {
  description = "AWS profile we're readings credentials from, read from TF_VAR_profile env var"
}

variable "bucket" {
  description = "S3 bucket Terraform config is stored in, read from TF_VAR_bucket env var"
}

variable "horizon_app_bucket" {
  description = "Name of the bucket the render app will ouput to"
}