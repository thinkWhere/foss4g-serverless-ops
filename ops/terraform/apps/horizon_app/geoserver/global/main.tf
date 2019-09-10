#########
# ECR
#########

resource "aws_ecr_repository" "geoserver" {
  # Create an Elastic Container Repo for the flask-bootstrap project
  name = "geoserver"
}


##########
# ECS
##########

resource "aws_ecs_cluster" "geoserver_ecs_cluster" {
  # Creates new ECS cluster
  name = "geoserver-cluster"
}

#######################
# Cloud Watch
######################

resource "aws_cloudwatch_log_group" "geoserver_ecs_cloudwatch_logs" {
  # Create log group for collection and analysis.  Logs that the container will generate will automatically
  # be pushed to this group
  name = "geoserver-cluster-logs"
  retention_in_days = 7

  tags = {
    Application = "geoserver-ecs"
  }
}


###########################
# Fargate Task Definition
############################

resource "aws_ecs_task_definition" "geoserver_ecs_task_def" {
  # Task definition describes docker container, logging etc
  family                   = "geoserver-ecs"

  # TODO could test to see if geoserver would run in a smaller container.
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 4096
  network_mode             = "awsvpc"  # allocates task a network interface

  execution_role_arn       = data.terraform_remote_state.iam_ecs.outputs.ecs_service_role
  task_role_arn            = data.terraform_remote_state.iam_ecs.outputs.ecs_task_role

  container_definitions    = templatefile("task_definitions/geoserver.json",
                                { region = var.region
                                  repo_url = aws_ecr_repository.geoserver.repository_url
                                  cloud_watch_group = aws_cloudwatch_log_group.geoserver_ecs_cloudwatch_logs.name})
}