output "ecs_service_role" {
  description = "ARN of the ECS service role"
  value       = aws_iam_role.ecs_service_role.arn
}

output "ecs_task_role" {
  description = "ARN of the ECS task role"
  value       = aws_iam_role.ecs_task_role.arn
}

