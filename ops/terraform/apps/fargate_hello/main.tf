#########
# ECR
#########

resource "aws_ecr_repository" "fargate_hello" {
  # Create an Elastic Container Repo for the flask-bootstrap project
  name = "fargate-hello"
}


##########
# ECS
##########

resource "aws_ecs_cluster" "fargate_hello_cluster" {
  # Creates new ECS cluster
  name = "fargate-hello-cluster"
}

#######################
# Cloud Watch
######################

resource "aws_cloudwatch_log_group" "fargate_hello_cloudwatch_logs" {
  # Create log group for collection and analysis.  Logs that the container will generate will automatically
  # be pushed to this group
  name = "fargate-hello-cluster"
  retention_in_days = 7

  tags = {
    Application = "fargate-hello"
  }
}


#######################
# Fargate
######################

resource "aws_ecs_task_definition" "fargate-hello-task" {
  # Task definition describes docker container, logging etc
  family                   = "fargate-hello"

  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"  # allocates task a network interface

  execution_role_arn       = data.terraform_remote_state.iam_ecs.outputs.ecs_service_role
  task_role_arn            = data.terraform_remote_state.iam_ecs.outputs.ecs_task_role

  container_definitions    = templatefile("task_definitions/fargate_hello.json",
                                { region = var.region
                                  repo_url =  aws_ecr_repository.fargate_hello.repository_url
                                  cloud_watch_group = aws_cloudwatch_log_group.fargate_hello_cloudwatch_logs.name})
}
