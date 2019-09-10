resource "aws_s3_bucket" "horizon_app_bucket" {
  # This bucket used by the horizon app to write redered images to
  bucket = "horizon-app-test1"

  tags = {
    Owner       = "foss4g"
    Name        = "horizon-app-test1"
    Environment = "Production"
  }
}