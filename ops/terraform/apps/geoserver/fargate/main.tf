resource "aws_cloudwatch_log_group" "geoserver_ecs_cloudwatch_logs" {
  # Create log group for collection and analysis.  Logs that the container will generate will automatically
  # be pushed to this group
  name = "geoserver-cluster-logs"
  retention_in_days = 7

  tags = {
    Application = "geoserver-ecs"
  }
}

resource "aws_ecs_task_definition" "geoserver_ecs_task_def" {
  # Task definition describes docker container, logging etc
  family                   = "geoserver-ecs"

  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"  # allocates task a network interface

  execution_role_arn       = data.terraform_remote_state.global_geoserver_ecs.outputs.ecs_service_role
  task_role_arn            = data.terraform_remote_state.global_geoserver_ecs.outputs.ecs_task_role

  container_definitions    = templatefile("task_definitions/geoserver.json",
                                { region = var.region
                                  repo_url = data.terraform_remote_state.global_geoserver_ecs.outputs.ecr_repo_url
                                  cloud_watch_group = aws_cloudwatch_log_group.geoserver_ecs_cloudwatch_logs.name})
}