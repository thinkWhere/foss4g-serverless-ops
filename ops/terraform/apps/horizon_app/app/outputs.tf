output "horizon_app_view_bucket" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.horizon_app_bucket.bucket
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.horizon_app_cluster.arn
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.horizon_app_cluster.name
}

output "ecr_repo_url" {
  description = "ARN of the ECR repo"
  value       = aws_ecr_repository.horizon_app_ecr.repository_url
}
