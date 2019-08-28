output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.fargate_hello_cluster.arn
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.fargate_hello_cluster.name
}

output "ecr_repo_url" {
  description = "ARN of the ECR repo"
  value       = aws_ecr_repository.fargate_hello.repository_url
}
