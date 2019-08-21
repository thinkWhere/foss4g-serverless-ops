###########
# Config
###########

variable "region" {
  description = "AWS region we're operating in, read from TF_VAR_region env var"
}

variable "profile" {
  description = "AWS profile we're readings credentials from, read from TF_VAR_profile env var"
}
