output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.geoserver_ecs_cluster.arn
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.geoserver_ecs_cluster.name
}

output "ecr_repo_url" {
  description = "ARN of the ECR repo"
  value       = aws_ecr_repository.geoserver.repository_url
}

output "task_definition_arn" {
  description = "ARN of the Geoserver Task definition"
  value       = aws_ecs_task_definition.geoserver_ecs_task_def.arn
}
