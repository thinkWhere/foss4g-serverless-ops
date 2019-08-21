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

variable "db_appsstaging_pass" {
  description = "Admin password for RDS instance read from TF_VAR_db_appsstaging_pass env var"
}